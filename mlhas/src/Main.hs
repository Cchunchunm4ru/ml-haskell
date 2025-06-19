module Main where

import Layers.TransformerLayer (TransformerLayer(..), forward)

main :: IO ()
main = do
    -- Example input: 2 rows × 3 columns
    let inp = [ [1.0, 2.0, 3.0],
                [4.0, 5.0, 6.0] ]

    -- Dummy TransformerLayer with small weights
    let layer = TransformerLayer
            { wq = [ [0.1, 0.2, 0.3],
                     [0.4, 0.5, 0.6],
                     [0.7, 0.8, 0.9] ]
            , wk = [ [0.1, 0.2, 0.3],
                     [0.4, 0.5, 0.6],
                     [0.7, 0.8, 0.9] ]
            , wv = [ [0.1, 0.2, 0.3],
                     [0.4, 0.5, 0.6],
                     [0.7, 0.8, 0.9] ]
            , wo = [ [0.1, 0.2, 0.3],
                     [0.4, 0.5, 0.6],
                     [0.7, 0.8, 0.9] ]
            , w1 = [ [0.1, 0.2, 0.3, 0.4],
                     [0.5, 0.6, 0.7, 0.8],
                     [0.9, 1.0, 1.1, 1.2] ]
            , b1 = [0.1, 0.1, 0.1, 0.1]
            , w2 = [ [0.1, 0.2, 0.3],
                     [0.4, 0.5, 0.6],
                     [0.7, 0.8, 0.9],
                     [1.0, 1.1, 1.2] ]
            , b2 = [0.1, 0.1, 0.1]
            }

    let out = forward layer inp

    putStrLn "Transformer Layer output:"
    mapM_ print out
