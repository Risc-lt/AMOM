module Scenes.Level1.Characters exposing (..)

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
            { strength = 40
            , dexterity = 25
            , constitution = 35
            , intelligence = 20
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
        ]


bruce : Int -> Self
bruce time =
    let
        baseAttributes =
            { strength = 25
            , dexterity = 40
            , constitution = 25
            , intelligence = 30
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
        ]


bulingze : Int -> Self
bulingze time =
    let
        baseAttributes =
            { strength = 20
            , dexterity = 30
            , constitution = 25
            , intelligence = 45
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
        ]


bithif : Int -> Self
bithif time =
    let
        baseAttributes =
            { strength = 25
            , dexterity = 30
            , constitution = 30
            , intelligence = 35
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
            wolves time
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
