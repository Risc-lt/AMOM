module SceneProtos.Game.Components.GenRandom exposing
    ( checkRate
    , genRandomNum
    )

{-|


# GenRandom module

This module is used to generate random numbers for the game.

@docs checkRate: Check the rate
@docs genRandomNum: Generate a random number

-}

import Random


checkRate : Int -> Int -> Bool
checkRate time rate =
    let
        randomNum =
            genRandomNum 1 100 time
    in
    if randomNum <= rate then
        True

    else
        False


genRandomNum : Int -> Int -> Int -> Int
genRandomNum lowerBound upperBound time =
    let
        ( value, _ ) =
            Random.step (Random.int lowerBound upperBound) <|
                Random.initialSeed <|
                    time
    in
    value
