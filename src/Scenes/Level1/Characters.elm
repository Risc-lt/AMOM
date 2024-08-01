module Scenes.Level1.Characters exposing (selfInitData, enemyInitData)

{-|


# Characters module

This module contains the character data for the Level1 scene.

@docs selfInitData, enemyInitData

-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (..)


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
    oneChar time 1 40 25 35 20 10 10 20 10 "Wenderd" <|
        [ arcaneBeam
        , airBlade
        ]


bruce : Int -> Self
bruce time =
    oneChar time 2 25 40 25 30 20 10 10 10 "Bruce" <|
        [ arcaneBeam
        , scatterShot
        ]


bulingze : Int -> Self
bulingze time =
    oneChar time 4 20 30 25 45 10 20 10 10 "Bulingze" <|
        [ arcaneBeam
        , fireBall
        ]


bithif : Int -> Self
bithif time =
    oneChar time 5 25 30 30 35 10 10 20 10 "Bithif" <|
        [ arcaneBeam
        , compounding
        , { magicWater | cost = 1 }
        , { poison | cost = 1 }
        ]


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


wolves : Int -> List Enemy
wolves time =
    let
        baseAttributes =
            { strength = 35
            , dexterity = 40
            , constitution = 25
            , intelligence = 10
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 8
            , airResistance = 15
            , earthResistance = 15
            }
    in
    List.map
        (\p ->
            genEnemy p time "Wild Wolf" baseAttributes baseEleResistance []
        )
        (List.range 7 12)


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
            wolves time

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
