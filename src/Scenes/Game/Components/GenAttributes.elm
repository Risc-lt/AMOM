module Scenes.Game.Components.GenAttributes exposing (..)


import Scenes.Game.Components.GenRandom exposing (..)


{-| basic attributes of the characters
-}
type alias Attribute =
    { strength : Int
    , dexterity : Int
    , constitution : Int
    , intelligence : Int
    }


{-| Additional attributes of the characters
-}
type alias ExtendValue =
    { basicStatus : BasicStatus
    , actionPoints : Int
    , ratioValues : RatioValues
    , eleResistance : EleResistance
    }


{-| Basic status of the characters
-}
type alias BasicStatus = 
    { maxHp : Int
    , maxMp : Int
    }


{-| Ratio values of the characters
-}
type alias RatioValues =
    { avoidRate : Int
    , normalHitRate : Int
    , magicalHitRate : Int
    , criticalHitRate : Int
    , counterRate : Int
    }


{-| Elemental resistance of the characters
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


genHp : Attribute -> Int
genHp attributes = 
    attributes.constitution * 10


genMp : Attribute -> Int
genMp attributes = 
    attributes.intelligence


genBasicStatus : Attribute -> BasicStatus
genBasicStatus attributes = 
    { maxHp = genHp attributes
    , maxMp = genMp attributes
    }


genActionPoints : Attribute -> Int -> Int
genActionPoints attributes time =
    let
        upperBound =
            attributes.dexterity
    in
    genRandomNum 1 upperBound time


genAvoidRate : Attribute -> Int
genAvoidRate attributes =
    attributes.dexterity


genNormalHitRate : Attribute -> Int
genNormalHitRate attributes =
    60 + attributes.dexterity + attributes.intelligence


genMagicalHitRate : Attribute -> Int
genMagicalHitRate attributes =
    80 + attributes.intelligence


genCriticalHitRate : Int
genCriticalHitRate =
    10


genCounterRate : Attribute -> Int
genCounterRate attributes =
    (attributes.dexterity + attributes.intelligence) // 4


genRatioValues : Attribute -> RatioValues
genRatioValues attributes =
    { avoidRate = genAvoidRate attributes
    , normalHitRate = genNormalHitRate attributes
    , magicalHitRate = genMagicalHitRate attributes
    , criticalHitRate = genCriticalHitRate
    , counterRate = genCounterRate attributes
    }


genSpecificResistance : Int -> Attribute -> Int
genSpecificResistance baseResistance attributes =
    baseResistance + attributes.intelligence


genEleResistence : Attribute -> Int -> Int -> Int -> Int -> EleResistance
genEleResistence attributes water fire air earth =
    { waterResistance = genSpecificResistance water attributes
    , fireResistance = genSpecificResistance fire attributes
    , airResistance = genSpecificResistance air attributes
    , earthResistance = genSpecificResistance earth attributes
    }


genExtendValues : Attribute -> Int -> Int -> Int -> Int -> Int -> ExtendValue
genExtendValues attributes time water fire air earth =
    { basicStatus = genBasicStatus attributes
    , actionPoints = genActionPoints attributes time
    , ratioValues = genRatioValues attributes
    , eleResistance = genEleResistence attributes water fire air earth
    }

defaultAttributes : Attribute
defaultAttributes = 
    { strength = 0
    , dexterity = 0
    , constitution = 0
    , intelligence = 0
    }

defaultBasicStatus : BasicStatus
defaultBasicStatus =
    { maxHp = 0
    , maxMp = 0
    }

defaultRatioValues : RatioValues
defaultRatioValues = 
    { avoidRate = 0
    , normalHitRate = 0
    , magicalHitRate = 0
    , criticalHitRate = 0
    , counterRate = 0
    }

defaultEleResistance : EleResistance
defaultEleResistance =
    { waterResistance = 0
    , fireResistance = 0
    , airResistance = 0
    , earthResistance = 0
    }

defaultExtendValues : ExtendValue
defaultExtendValues =
    { basicStatus = defaultBasicStatus
    , actionPoints = 0
    , ratioValues = defaultRatioValues
    , eleResistance = defaultEleResistance
    }
