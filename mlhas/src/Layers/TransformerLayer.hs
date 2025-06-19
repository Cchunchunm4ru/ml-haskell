{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Redundant bracket" #-}
module Layers.TransformerLayer (TransformerLayer(..), forward) where
import Layers.Activation.Softmax

mean :: (Fractional a) => [a] -> a
mean xs = sum xs / fromIntegral (length xs)

std :: (Floating a) => [a] -> a
std xs = sqrt (sum [ (x - m) **2 | x <- xs ] / fromIntegral (length xs))
    where m = mean xs

layerNorm :: [Float] -> [Float]
layerNorm x =
    let m = mean x
        s = std x
    in [ (xi - m) / (s + 1e-6) | xi <- x ]

type Matrix = [[Float]]

transpose :: Matrix -> Matrix
transpose ([]:_) = []
transpose x = map head x : transpose (map tail x)

matMul :: Matrix -> Matrix -> Matrix
matMul a b =
    let bt = transpose b
    in [ [ sum $ zipWith (*) row col | col <- bt ] | row <- a ]

relu :: Matrix -> Matrix
relu = map (map (\x -> max 0 x))

attention :: Matrix -> Matrix -> Matrix -> Matrix
attention q k v =
    let dk = sqrt (fromIntegral (length (head k)))
        scores = matMul q (transpose k)
        scaledScores = [ [ s / dk | s <- row ] | row <- scores ]
        weights = map softmax scaledScores
    in matMul weights v

data TransformerLayer = TransformerLayer
    { wq :: Matrix
    , wk :: Matrix
    , wv :: Matrix
    , wo :: Matrix
    , w1 :: Matrix
    , b1 :: [Float]
    , w2 :: Matrix
    , b2 :: [Float]
    }

forward :: TransformerLayer -> Matrix -> Matrix
forward layer x =
    let q = matMul x (wq layer)
        k = matMul x (wk layer)
        v = matMul x (wv layer)

        attnOut = attention q k v
        attnProj = matMul attnOut (wo layer)

        x1 = zipWith (\xi ai -> layerNorm (zipWith (+) xi ai)) x attnProj

        ff1 = relu (matMul x1 (w1 layer) `addBias` (b1 layer))
        ff2 = matMul ff1 (w2 layer) `addBias` (b2 layer)

        out = zipWith (\xi fi -> layerNorm (zipWith (+) xi fi)) x1 ff2
    in out

addBias :: Matrix -> [Float] -> Matrix
addBias m b = [ zipWith (+) row b | row <- m ]
