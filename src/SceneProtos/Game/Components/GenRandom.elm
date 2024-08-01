module SceneProtos.Game.Components.GenRandom exposing
    ( checkRate
    , genRandomNum
    )

import Random


{-| Check the rate
-}
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


{-| Generate a random number
-}
genRandomNum : Int -> Int -> Int -> Int
genRandomNum lowerBound upperBound time =
    let
        ( value, _ ) =
            Random.step (Random.int lowerBound upperBound) <|
                Random.initialSeed <|
                    time
    in
    value
