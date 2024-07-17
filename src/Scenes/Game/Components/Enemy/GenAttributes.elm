module Scenes.Game.Components.Enemy.GenAttributes exposing (..)

import Random


{-| Core data structure for the enemy
-}
type alias Enemy =
    { x : Float
    , y : Float
    , position : Int
    , attributes : Attribute
    , extendValues : ExtendValue
    }


{-| basic attributes of the enemy
-}
type alias Attribute =
    { strength : Int
    , dexterity : Int
    , constitution : Int
    , intelligence : Int
    }


{-| Additional attributes of the enemy
-}
type alias ExtendValue =
    { basicStatus : BasicStatus
    , actionPoints : Int
    , rateValues : RatioValues
    , eleResistance : EleResistance
    }


{-| Basic status of the Enemy
-}
type alias BasicStatus = 
    { hp : Int
    , maxHp : Int
    , mp : Int
    , maxMp : Int
    , energy : Int
    }


{-| Ratio values of the Enemy
-}
type alias RatioValues =
    { avoidRate : Int
    , normalHitRate : Int
    , magicalHitRate : Int
    , criticalHitRate : Int
    , counterRate : Int
    }


{-| Elemental resistance of the Enemy
-}
type alias EleResistance = 
    { waterResistance : Int
    , fireResistance : Int
    , airResistance : Int
    , earthResistance : Int
    }


type Element
    = Water
    | Fire
    | Air
    | Earth


genHp : Enemy -> Int
genHp enemy = 
    enemy.attributes.constitution * 10


genMp : Enemy -> Int
genMp enemy = 
    enemy.attributes.intelligence


genBasicStatus : Enemy -> Int -> BasicStatus
genBasicStatus enemy energy = 
    { hp = genHp enemy
    , maxHp = genHp enemy
    , mp = genMp enemy
    , maxMp = genMp enemy
    , energy = energy
    }


genRandomNum : Int -> Int -> Int -> Int
genRandomNum lowerBound upperBound time =
    let
        ( value, _ ) =
            Random.step (Random.int lowerBound upperBound) <|
                Random.initialSeed <|
                    time
    in
    value


genActionPoints : Enemy -> Int -> Int
genActionPoints enemy time =
    let
        upperBound =
            enemy.attributes.dexterity
    in
    genRandomNum 1 upperBound time


genAvoidRate : Enemy -> Int
genAvoidRate enemy =
    enemy.attributes.dexterity


genNormalHitRate : Enemy -> Int
genNormalHitRate enemy =
    60 + enemy.attributes.dexterity + enemy.attributes.intelligence


genMagicalHitRate : Enemy -> Int
genMagicalHitRate enemy =
    80 + enemy.attributes.intelligence


genCriticalHitRate : Int
genCriticalHitRate =
    10


genCounterRate : Enemy -> Int
genCounterRate enemy =
    (enemy.attributes.dexterity + enemy.attributes.intelligence) // 4


genRatioValues : Enemy -> RatioValues
genRatioValues enemy =
    { avoidRate = genAvoidRate enemy
    , normalHitRate = genNormalHitRate enemy
    , magicalHitRate = genMagicalHitRate enemy
    , criticalHitRate = genCriticalHitRate
    , counterRate = genCounterRate enemy
    }


genSpecificResistance : Int -> Enemy -> Int
genSpecificResistance baseResistance enemy =
    baseResistance + enemy.attributes.intelligence


genEleResistence : Enemy -> Int -> Int -> Int -> Int -> EleResistance
genEleResistence enemy water fire air earth =
    { waterResistance = genSpecificResistance water enemy
    , fireResistance = genSpecificResistance fire enemy
    , airResistance = genSpecificResistance air enemy
    , earthResistance = genSpecificResistance earth enemy
    }
