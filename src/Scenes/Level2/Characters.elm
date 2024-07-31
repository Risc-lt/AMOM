module Scenes.Level2.Characters exposing (..)

{-
   All character data
-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (..)


oneChar : Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> String -> List Skill -> Self
oneChar time pos str dex con int water fire air earth name skills =
    let
        baseAttributes =
            { strength = str
            , dexterity = dex
            , constitution = con
            , intelligence = int
            }

        baseEleResistance =
            { waterResistance = water
            , fireResistance = fire
            , airResistance = air
            , earthResistance = earth
            }
    in
    genSelf pos
        time
        name
        baseAttributes
        baseEleResistance
        skills


wenderd : Int -> Self
wenderd time =
    oneChar time 1 48 30 38 24 10 10 20 10 "Wenderd" <|
        [ arcaneBeam, airBlade, doubleStrike, { poison | cost = 1 } ]


bruce : Int -> Self
bruce time =
    oneChar time 2 30 46 28 36 20 10 10 10 "Bruce" <|
        [ arcaneBeam, scatterShot, frostArrow, frostImpact, { poison | cost = 1 } ]


bulingze : Int -> Self
bulingze time =
    oneChar time 4 24 33 28 55 10 20 10 10 "Bulingze" <|
        [ arcaneBeam, fireBall, inspirationOfFire, { magicWater | cost = 1 } ]


bithif : Int -> Self
bithif time =
    oneChar time 5 30 36 32 42 10 10 20 10 "Bithif" <|
        [ arcaneBeam, compounding, magicTransformation, whirlwindAccelaration, { magicWater | cost = 1 }, { poison | cost = 1 } ]


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
