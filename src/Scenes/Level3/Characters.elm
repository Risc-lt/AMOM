module Scenes.Level3.Characters exposing
    ( enemyInitData
    , selfInitData
    )

{-
   All character data
-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (..)
import Scenes.Level3.CharacterBase exposing (bithif, bruce, bulingze, cavalry, genSelf, wenderd)


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
            , cavalry time
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


swordsman : Int -> List Enemy
swordsman time =
    let
        baseAttributes =
            { strength = 35
            , dexterity = 30
            , constitution = 35
            , intelligence = 40
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 20
            , earthResistance = 10
            }
    in
    List.map
        (\p ->
            genEnemy p time "Swordsman" baseAttributes baseEleResistance [ arcaneBeam, lightningSpell ]
        )
        (List.range 7 9)


magician : Int -> List Enemy
magician time =
    let
        baseAttributes =
            { strength = 25
            , dexterity = 30
            , constitution = 35
            , intelligence = 50
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 20
            , earthResistance = 10
            }
    in
    List.map
        (\p ->
            genEnemy p time "Magician" baseAttributes baseEleResistance [ arcaneBeam, lightningSpell, chainLightning ]
        )
        (List.range 10 11)


therapist : Int -> List Enemy
therapist time =
    let
        baseAttributes =
            { strength = 30
            , dexterity = 30
            , constitution = 35
            , intelligence = 45
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 20
            , earthResistance = 10
            }
    in
    [ genEnemy 12 time "Therapist" baseAttributes baseEleResistance [ arcaneBeam, lightningSpell, whirlwindAccelaration, cure ] ]


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
            swordsman time
                ++ magician time
                ++ therapist time
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
