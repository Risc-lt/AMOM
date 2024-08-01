module Scenes.Level2.Characters exposing (selfInitData, enemyInitData)

{-|


# Level2 Characters module

This module contains all character data for Level2 scene

@docs selfInitData, enemyInitData

-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.SpeSkill exposing (..)
import SceneProtos.Game.Components.Special.Magic exposing (..)
import SceneProtos.Game.Components.Special.Item exposing (..)


type alias Character =
    { name : String
    , x : Int
    , y : Float
    , position : Int
    , hp : Int
    , mp : Int
    , attributes : Attribute
    , extendValues : ExtendValue
    , skills : List Skill
    }


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


genChar : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Bool -> Character
genChar position time name baseAttributes baseEleResistance skills flag =
    { name = name
    , x =
        if flag then
            if position <= 3 then
                1100

            else
                1220

        else if position <= 9 then
            230

        else
            100
    , y =
        if flag then
            toFloat (160 + 130 * (position - (position - 1) // 3 * 3 - 1))

        else
            toFloat (160 + 130 * (position - (position - 7) // 3 * 3 - 7))
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


convert : Character -> ( Self, Enemy )
convert char =
    ( { defaultSelf
        | name = char.name
        , x = toFloat char.x
        , y = char.y
        , position = char.position
        , hp = char.hp
        , mp = char.mp
        , attributes = char.attributes
        , extendValues = char.extendValues
        , skills = char.skills
      }
    , { defaultEnemy
        | name = char.name
        , x = toFloat char.x
        , y = char.y
        , position = char.position
        , hp = char.hp
        , mp = char.mp
        , attributes = char.attributes
        , extendValues = char.extendValues
        , skills = char.skills
      }
    )


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
    let
        ( self, _ ) =
            convert
                (genChar position time name baseAttributes baseEleResistance skills True)
    in
    self


genEnemy : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Enemy
genEnemy position time name baseAttributes baseEleResistance skills =
    let
        ( _, enemy ) =
            convert
                (genChar position time name baseAttributes baseEleResistance skills False)
    in
    enemy


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


initData : Int -> ( List Self, List Enemy )
initData time =
    let
        default =
            List.map
                (\p ->
                    ( genSelf p time "" defaultAttributes defaultEleResistance []
                    , genEnemy (p + 6) time "" defaultAttributes defaultEleResistance []
                    )
                )
                (List.range 1 6)

        ( defaultSelfs, defaultEnemies ) =
            List.unzip default

        selfs =
            [ wenderd time
            , bruce time
            , bulingze time
            , bithif time
            ]

        enemies =
            [ concert time ]

        resSelfs =
            List.filter
                (\d ->
                    List.all
                        (\s ->
                            s.position /= d.position
                        )
                        selfs
                )
                defaultSelfs
                ++ selfs

        resEnemies =
            List.filter
                (\d ->
                    List.all
                        (\s ->
                            s.position /= d.position
                        )
                        enemies
                )
                defaultEnemies
                ++ enemies
    in
    ( resSelfs, resEnemies )


{-| Init data for selfs
-}
selfInitData : Int -> List Self
selfInitData time =
    let
        ( selfs, _ ) =
            initData time
    in
    selfs


{-| Init data for enemies
-}
enemyInitData : Int -> List Enemy
enemyInitData time =
    let
        ( _, enemies ) =
            initData time
    in
    enemies
