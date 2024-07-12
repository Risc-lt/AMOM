module Scenes.Game.Components.Enemy.Init exposing
    ( InitData
    , Enemy, defaultEnemy, emptyInitData
    )

{-|


# Init module

@docs InitData

-}


{-| Core data structure for the enemy
-}
type alias Enemy =
    { x : Float
    , y : Float
    , hp : Float
    , position : Int
    , race : String
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    List Enemy


{-| Empty init data for enemy
-}
emptyInitData : InitData
emptyInitData =
    List.map
        (\p ->
            { x = 230
            , y = toFloat (160 + 130 * (p - 1))
            , hp = 100
            , position = p
            , race = "Physical"
            }
        )
        [ 1, 2, 3 ]
        ++ List.map
            (\p ->
                { x = 100
                , y = toFloat (160 + 130 * (p - 4))
                , hp = 100
                , position = p
                , race = "Magical"
                }
            )
            [ 4, 5, 6 ]


{-| Default enemy
-}
defaultEnemy : Enemy
defaultEnemy =
    { x = 100
    , y = 100
    , hp = 100
    , position = 1
    , race = "Physical"
    }
