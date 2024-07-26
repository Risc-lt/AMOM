module SceneProtos.Game.Components.Enemy.Init exposing
    ( InitData
    , Enemy, State(..), defaultEnemy, emptyInitData, genDefaultEnemy
    )

{-|


# Init module

@docs InitData

-}

import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)


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
    }


{-| -}
genDefaultEnemy : Int -> Enemy
genDefaultEnemy id =
    { name = "Wild Wolf"
    , x =
        if id >= 7 && id <= 9 then
            230

        else
            100
    , y =
        if id >= 7 && id <= 9 then
            toFloat (160 + 130 * (id - 7))

        else
            toFloat (160 + 130 * (id - 10))
    , position = id
    , hp = genHp baseAttributes
    , mp = genMp baseAttributes
    , energy = 0
    , attributes = baseAttributes
    , extendValues =
        genExtendValues
            baseAttributes
            10
            baseEleResistance.waterResistance
            baseEleResistance.fireResistance
            baseEleResistance.airResistance
            baseEleResistance.earthResistance
    , buff = []
    , skills = []
    , state = Waiting
    }
