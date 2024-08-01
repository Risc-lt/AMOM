module Scenes.Level3.Characters exposing (enemyInitData, selfInitData)

{-|


# Characters module

This module contains the character data for the Level3 scene.

@docs enemyInitData, selfInitData

-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.SpeSkill exposing (..)
import SceneProtos.Game.Components.Special.Magic exposing (..)
import Scenes.Level3.CharacterBase exposing (bithif, bruce, bulingze, cavalry, convert, genChar, genSelf, wenderd)


{-| Generate an enemy
-}
genEnemy : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Enemy
genEnemy position time name baseAttributes baseEleResistance skills =
    let
        ( _, enemy ) =
            convert
                (genChar position time name baseAttributes baseEleResistance skills False)
    in
    enemy


oneEnemy : Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> String -> List Skill -> Enemy
oneEnemy time pos str dex con int water fire air earth name skills =
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
    genEnemy pos
        time
        name
        baseAttributes
        baseEleResistance
        skills


swordsman : Int -> List Enemy
swordsman time =
    List.map
        (\p ->
            oneEnemy time p 35 30 35 40 10 10 20 10 "Swordsman" [ arcaneBeam, lightningSpell ]
        )
        (List.range 7 9)


magician : Int -> List Enemy
magician time =
    List.map
        (\p ->
            oneEnemy time p 25 30 35 50 10 10 20 10 "Magician" [ arcaneBeam, lightningSpell, chainLightning ]
        )
        (List.range 10 11)


therapist : Int -> List Enemy
therapist time =
    [ oneEnemy time 12 30 30 35 45 10 10 20 10 "Therapist" [ arcaneBeam, lightningSpell, whirlwindAccelaration, cure ] ]


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
            , cavalry time
            ]

        enemies =
            swordsman time
                ++ magician time
                ++ therapist time

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
