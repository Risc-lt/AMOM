module Scenes.Game.Components.Enemy.Init exposing
    ( InitData
    , defaultEnemy, emptyInitData
    )

{-|


# Init module

@docs InitData

-}


import Scenes.Game.Components.Enemy.GenAttributes exposing (..)


{-| The data used to initialize the scene
-}
type alias InitData =
    List Enemy


{-| Base attributes for the self
-}
baseAttributes : Attribute
baseAttributes =
    { strength = 20
    , dexterity = 20
    , constitution = 20
    , intelligence = 20
    }


{-| Empty init data for enemy
-}
emptyInitData : InitData
emptyInitData =
    List.map
        (\p ->
            { x = 230
            , y = toFloat (160 + 130 * (p - 7))
            , position = p
            , attributes = baseAttributes
            }
        )
        [ 7, 8, 9 ]
        ++ List.map
            (\p ->
                { x = 100
                , y = toFloat (160 + 130 * (p - 10))
                , position = p
                , attributes = baseAttributes
                }
            )
            [ 10, 11, 12 ]


{-| Default enemy
-}
defaultEnemy : Enemy
defaultEnemy =
    { x = 100
    , y = 100
    , hp = 100
    , position = 7
    , attributes = baseAttributes
    }
