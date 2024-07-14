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
    , attributes : Attribute
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    List Enemy

{-| Additional attributes of the enemy
-}
type alias Attribute =
    { strength : Float
    , agility : Float
    , stamina : Float
    , spirit : Float
    , waterResistance : Float
    , fireResistance : Float
    , windResistance : Float
    , earthResistance : Float
    }


{-| Base attributes for the self
-}
baseAttributes : Attribute
baseAttributes =
    { strength = 10
    , agility = 10
    , stamina = 10
    , spirit = 10
    , waterResistance = 0.1
    , fireResistance = 0.1
    , windResistance = 0.1
    , earthResistance = 0.1
    }


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
            , attributes = baseAttributes
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
                , attributes = baseAttributes
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
    , attributes = baseAttributes
    }
