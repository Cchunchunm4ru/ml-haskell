module Layers.Activation.Softmax where

expx ::[Float]-> [Float]
expx xs = [exp(x) |x<-xs]

softmax::[Float] -> [Float]
softmax xs = 
    let exps = expx xs
        sumexps = sum exps
    in [ x / sumexps| x <- exps]