module Scenes.Level3.CharacterBase exposing
    ( bithif
    , bruce
    , bulingze
    , cavalry
    , genSelf
    , wenderd
    )

import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (..)


{-| Generate a self
-}
genSelf : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Self
genSelf position time name baseAttributes baseEleResistance skills =
    { defaultSelf
        | name = name
        , x =
            if position <= 3 then
                1100

            else
                1220
        , y = toFloat (160 + 130 * (position - (position - 1) // 3 * 3 - 1))
        , position = position
        , hp = genHp baseAttributes
        , mp = genMp baseAttributes
        , attributes = baseAttributes
        , extendValues =
            genExtendValues
                baseAttributes
                (time + position)
                baseEleResistance.waterResistance
                baseEleResistance.fireResistance
                baseEleResistance.airResistance
                baseEleResistance.earthResistance
        , skills = skills
    }


{-| Wendard base attributes
-}
wenderd : Int -> Self
wenderd time =
    let
        baseAttributes =
            { strength = 56
            , dexterity = 34
            , constitution = 42
            , intelligence = 28
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 20
            , earthResistance = 10
            }
    in
    genSelf 1
        time
        "Wenderd"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , airBlade
        , doubleStrike
        , { poison | cost = 1 }
        ]


{-| Bruce base attributes
-}
bruce : Int -> Self
bruce time =
    let
        baseAttributes =
            { strength = 35
            , dexterity = 55
            , constitution = 30
            , intelligence = 40
            }

        baseEleResistance =
            { waterResistance = 20
            , fireResistance = 10
            , airResistance = 10
            , earthResistance = 10
            }
    in
    genSelf 2
        time
        "Bruce"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , scatterShot
        , frostArrow
        , frostImpact
        , iceRing
        , { poison | cost = 1 }
        , { magicWater | cost = 1 }
        ]


{-| Bulingze base attributes
-}
bulingze : Int -> Self
bulingze time =
    let
        baseAttributes =
            { strength = 28
            , dexterity = 35
            , constitution = 32
            , intelligence = 65
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 20
            , airResistance = 10
            , earthResistance = 10
            }
    in
    genSelf 4
        time
        "Bulingze"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , fireBall
        , inspirationOfFire
        , blindness
        , { poison | cost = 1 }
        , { magicWater | cost = 1 }
        ]


{-| Bithif base attributes
-}
bithif : Int -> Self
bithif time =
    let
        baseAttributes =
            { strength = 34
            , dexterity = 40
            , constitution = 36
            , intelligence = 50
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 20
            , earthResistance = 10
            }
    in
    genSelf 6
        time
        "Bithif"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , compounding
        , magicTransformation
        , whirlwindAccelaration
        , gale
        , { magicWater | cost = 1 }
        , { poison | cost = 1 }
        , { restorationPotion | cost = 1 }
        ]


{-| Cavalry base attributes
-}
cavalry : Int -> Self
cavalry time =
    let
        baseAttributes =
            { strength = 40
            , dexterity = 30
            , constitution = 34
            , intelligence = 56
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 20
            , earthResistance = 10
            }
    in
    genSelf 5
        time
        "Cavalry"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , airBlade
        , lightningSpell
        , chainLightning
        , blessingOfAir
        , { restorationPotion | cost = 1 }
        ]
