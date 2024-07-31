module SceneProtos.Game.Components.GenAttributes exposing
    ( Attribute
    , BasicStatus
    , EleResistance
    , ExtendValue
    , RatioValues
    , defaultAttributes
    , defaultBasicStatus
    , defaultEleResistance
    , defaultExtendValues
    , defaultRatioValues
    , genActionPoints
    , genAvoidRate
    , genBasicStatus
    , genCounterRate
    , genCriticalHitRate
    , genEleResistence
    , genExtendValues
    , genHp
    , genMagicalHitRate
    , genMp
    , genNormalHitRate
    , genRatioValues
    , genSpecificResistance
    )

import SceneProtos.Game.Components.GenRandom exposing (..)


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


{-| Generate the HP of the character
-}
genHp : Attribute -> Int
genHp attributes =
    attributes.constitution * 5 + attributes.strength


{-| Generate the MP of the character
-}
genMp : Attribute -> Int
genMp attributes =
    attributes.intelligence


{-| Generate the basic status of the character
-}
genBasicStatus : Attribute -> BasicStatus
genBasicStatus attributes =
    { maxHp = genHp attributes
    , maxMp = genMp attributes
    }


{-| Generate the action points of the character
-}
genActionPoints : Attribute -> Int -> Int
genActionPoints attributes time =
    let
        upperBound =
            attributes.dexterity
    in
    genRandomNum 1 upperBound time


{-| Generate the avoid rate of the character
-}
genAvoidRate : Attribute -> Int
genAvoidRate attributes =
    attributes.dexterity


{-| Generate the normal hit rate of the character
-}
genNormalHitRate : Attribute -> Int
genNormalHitRate attributes =
    60 + attributes.dexterity + attributes.intelligence


{-| Generate the magical hit rate of the character
-}
genMagicalHitRate : Attribute -> Int
genMagicalHitRate attributes =
    80 + attributes.intelligence


{-| Generate the critical hit rate of the character
-}
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


{-| Generate the specific resistance of the character
-}
genSpecificResistance : Int -> Attribute -> Int
genSpecificResistance baseResistance attributes =
    baseResistance + attributes.intelligence


{-| Generate the elemental resistance of the character
-}
genEleResistence : Attribute -> Int -> Int -> Int -> Int -> EleResistance
genEleResistence attributes water fire air earth =
    { waterResistance = genSpecificResistance water attributes
    , fireResistance = genSpecificResistance fire attributes
    , airResistance = genSpecificResistance air attributes
    , earthResistance = genSpecificResistance earth attributes
    }


{-| Generate the extend values of the character
-}
genExtendValues : Attribute -> Int -> Int -> Int -> Int -> Int -> ExtendValue
genExtendValues attributes time water fire air earth =
    { basicStatus = genBasicStatus attributes
    , actionPoints = genActionPoints attributes time
    , ratioValues = genRatioValues attributes
    , eleResistance = genEleResistence attributes water fire air earth
    }


{-| Default attributes
-}
defaultAttributes : Attribute
defaultAttributes =
    { strength = 0
    , dexterity = 0
    , constitution = 0
    , intelligence = 0
    }


{-| Default basic status
-}
defaultBasicStatus : BasicStatus
defaultBasicStatus =
    { maxHp = 0
    , maxMp = 0
    }


{-| Default ratio values
-}
defaultRatioValues : RatioValues
defaultRatioValues =
    { avoidRate = 0
    , normalHitRate = 0
    , magicalHitRate = 0
    , criticalHitRate = 0
    , counterRate = 0
    }


{-| Default elemental resistance
-}
defaultEleResistance : EleResistance
defaultEleResistance =
    { waterResistance = 0
    , fireResistance = 0
    , airResistance = 0
    , earthResistance = 0
    }


{-| Default extend values
-}
defaultExtendValues : ExtendValue
defaultExtendValues =
    { basicStatus = defaultBasicStatus
    , actionPoints = 0
    , ratioValues = defaultRatioValues
    , eleResistance = defaultEleResistance
    }
