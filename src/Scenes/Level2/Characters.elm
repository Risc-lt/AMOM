module Scenes.Level2.Characters exposing (..)

{-
   All character data
-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)


wenderd : Int -> Self
wenderd time =
    let
        baseAttributes =
            { strength = 48
            , dexterity = 30
            , constitution = 38
            , intelligence = 24
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


bruce : Int -> Self
bruce time =
    let
        baseAttributes =
            { strength = 30
            , dexterity = 46
            , constitution = 28
            , intelligence = 36
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
        , { poison | cost = 1 }
        ]


bulingze : Int -> Self
bulingze time =
    let
        baseAttributes =
            { strength = 24
            , dexterity = 33
            , constitution = 28
            , intelligence = 55
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
        , { magicWater | cost = 1 }
        ]


bithif : Int -> Self
bithif time =
    let
        baseAttributes =
            { strength = 30
            , dexterity = 36
            , constitution = 32
            , intelligence = 42
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
        "Bithif"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , compounding
        , magicTransformation
        , whirlwindAccelaration
        , { magicWater | cost = 1 }
        , { poison | cost = 1 }
        ]


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


{-| Init data for selfs
-}
selfInitData : Int -> List Self
selfInitData time =
    let
        default =
            List.map
                (\p ->
                    genSelf p time "" defaultAttributes defaultEleResistance []
                )
                (List.range 1 6)

        selfs =
            [ wenderd time
            , bruce time
            , bulingze time
            , bithif time
            ]
    in
    List.filter
        (\d ->
            List.all
                (\s ->
                    s.position /= d.position
                )
                selfs
        )
        default
        ++ selfs


concert : Int -> Enemy
concert time =
    let
        baseAttributes =
            { strength = 60
            , dexterity = 45
            , constitution = 50
            , intelligence = 65
            }

        baseEleResistance =
            { waterResistance = 20
            , fireResistance = 30
            , airResistance = 20
            , earthResistance = 30
            }
    in
    genEnemy 8
        time
        "Concert"
        baseAttributes
        baseEleResistance
        [ arcaneBeam
        , airBlade
        , fieryThrust
        , fireBall
        , mudSwamp
        , stoneSkin
        , { magicWater | cost = 1 }
        , { restorationPotion | cost = 1 }
        ]


genEnemy : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Enemy
genEnemy position time name baseAttributes baseEleResistance skills =
    { defaultEnemy
        | name = name
        , x =
            if position <= 9 then
                230

            else
                100
        , y = toFloat (160 + 130 * (position - (position - 7) // 3 * 3 - 7))
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


{-| Init data for selfs
-}
enemyInitData : Int -> List Enemy
enemyInitData time =
    let
        default =
            List.map
                (\p ->
                    genEnemy p time "" defaultAttributes defaultEleResistance []
                )
                (List.range 7 12)

        enemies =
            [ concert time ]
    in
    List.filter
        (\d ->
            List.all
                (\s ->
                    s.position /= d.position
                )
                enemies
        )
        default
        ++ enemies
