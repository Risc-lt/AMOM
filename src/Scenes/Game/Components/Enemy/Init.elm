module Scenes.Game.Components.Enemy.Init exposing
    ( InitData
    , Enemy, emptyInitData
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
    , id : Int
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    Enemy


{-| Empty init data for enemy
-}
emptyInitData : InitData
emptyInitData =
    { x = 100
    , y = 100
    , hp = 100
    , id = 1
    }
