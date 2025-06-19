module Layers.Dense where

import Numeric.LinearAlgebra as LA

data Dense = Dense { weights :: Matrix Double
                   , bias    :: Vector Double
                   }

-- Create a Dense layer with random weights and biases
createDense :: Int -> Int -> IO Dense
createDense inputDim outputDim = do
    w <- randn inputDim outputDim
    b <- randn outputDim 1
    return $ Dense w (flatten b)

-- Forward pass
forward :: Dense -> Matrix Double -> Matrix Double
forward (Dense w b) x = (x LA.<> w) + repmat (asRow b) (rows x) 1
