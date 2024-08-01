module SceneProtos.Game.Components.Enemy.Init exposing
    ( InitData
    , Enemy, State(..)
    , defaultEnemy, emptyInitData
    , genDefaultEnemy
    )

{-|


# Init module

@docs InitData
@docs Enemy, State
@docs defaultEnemy, emptyInitData
@docs genDefaultEnemy

-}

import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.GenRandom exposing (genRandomNum)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (chainLightning, lightningSpell)


{-| Character state
-}
type State
    = Working
    | Waiting
    | Rest


{-| Core data structure for the enemy
-}
type alias Enemy =
    { name : String
    , x : Float
    , y : Float
    , position : Int
    , hp : Int
    , mp : Int
    , energy : Int
    , attributes : Attribute
    , skills : List Skill
    , extendValues : ExtendValue
    , buff : List ( Buff, Int )
    , state : State
    , curHurt : String
    , isRunning : Bool
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    List Enemy


{-| Base attributes for the enemy
-}
baseAttributes : Attribute
baseAttributes =
    { strength = 20
    , dexterity = 20
    , constitution = 20
    , intelligence = 20
    }


{-| Base elemental resistance for the enemy
-}
baseEleResistance : EleResistance
baseEleResistance =
    { waterResistance = 10
    , fireResistance = 10
    , airResistance = 10
    , earthResistance = 10
    }


{-| Empty init data for enemy
-}
emptyInitData : Int -> InitData
emptyInitData time =
    List.map
        (\p ->
            { name = "Wild Wolf"
            , x = 230
            , y = toFloat (160 + 130 * (p - 7))
            , position = p
            , hp = genHp baseAttributes
            , mp = genMp baseAttributes
            , energy = 0
            , attributes = baseAttributes
            , extendValues =
                genExtendValues
                    baseAttributes
                    (time + p)
                    baseEleResistance.waterResistance
                    baseEleResistance.fireResistance
                    baseEleResistance.airResistance
                    baseEleResistance.earthResistance
            , buff = []
            , skills = []
            , state = Waiting
            , curHurt = ""
            , isRunning = False
            }
        )
        [ 7, 8, 9 ]
        ++ List.map
            (\p ->
                { name = "Wild Wolf"
                , x = 100
                , y = toFloat (160 + 130 * (p - 10))
                , position = p
                , hp = genHp baseAttributes
                , mp = genMp baseAttributes
                , energy = 0
                , attributes = baseAttributes
                , extendValues =
                    genExtendValues
                        baseAttributes
                        (time + p)
                        baseEleResistance.waterResistance
                        baseEleResistance.fireResistance
                        baseEleResistance.airResistance
                        baseEleResistance.earthResistance
                , buff = []
                , skills = []
                , state = Waiting
                , curHurt = ""
                , isRunning = False
                }
            )
            [ 10, 11, 12 ]


{-| Default enemy
-}
defaultEnemy : Enemy
defaultEnemy =
    { name = "Wild Wolf"
    , x = 230
    , y = toFloat (160 + 130 * (7 - 7))
    , position = 7
    , hp = genHp baseAttributes
    , mp = genMp baseAttributes
    , energy = 0
    , attributes = baseAttributes
    , extendValues =
        genExtendValues
            baseAttributes
            5
            baseEleResistance.waterResistance
            baseEleResistance.fireResistance
            baseEleResistance.airResistance
            baseEleResistance.earthResistance
    , buff = []
    , skills = []
    , state = Waiting
    , curHurt = ""
    , isRunning = False
    }


{-| Generate default enemy
-}
genDefaultEnemy : Int -> Int -> Enemy
genDefaultEnemy time id =
    let
        random =
            genRandomNum 1 3 time

        ( name, attributes, skills ) =
            case random of
                1 ->
                    ( "Swordsman"
                    , { strength = 35
                      , dexterity = 30
                      , constitution = 35
                      , intelligence = 40
                      }
                    , [ arcaneBeam
                      , lightningSpell
                      ]
                    )

                2 ->
                    ( "Magician"
                    , { strength = 25
                      , dexterity = 30
                      , constitution = 35
                      , intelligence = 50
                      }
                    , [ arcaneBeam
                      , lightningSpell
                      , chainLightning
                      ]
                    )

                _ ->
                    ( "Therapist"
                    , { strength = 30
                      , dexterity = 30
                      , constitution = 35
                      , intelligence = 45
                      }
                    , [ arcaneBeam
                      , lightningSpell
                      , cure
                      , whirlwindAccelaration
                      ]
                    )
    in
    { defaultEnemy
        | name = name
        , x =
            if id <= 9 then
                230

            else
                100
        , y = toFloat (160 + 130 * (id - (id - 7) // 3 * 3 - 7))
        , position = id
        , hp = genHp attributes
        , mp = genMp attributes
        , attributes = attributes
        , extendValues =
            genExtendValues
                attributes
                (time + id)
                10
                10
                20
                10
        , skills = skills
    }
