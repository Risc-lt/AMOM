module Scenes.Game.Components.Enemy.Init exposing
    ( InitData
    , Enemy, defaultEnemy, emptyInitData
    )

{-|


# Init module

@docs InitData

-}

import Scenes.Game.Components.GenAttributes exposing (..)


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
    , extendValues : ExtendValue
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
                }
            )
            [ 10, 11, 12 ]


{-| Default enemy
-}
defaultEnemy : Enemy
defaultEnemy =
    { name = ""
    , x = 100
    , y = 100
    , position = 7
    , hp = 0
    , mp = 0
    , energy = 0
    , attributes = baseAttributes
    , extendValues = defaultExtendValues
    }
