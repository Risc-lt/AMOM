module Scenes.Game.Components.Self.Init exposing
    ( InitData
    , Self, State(..), emptyInitData
    )

{-|


# Init module

@docs InitData

-}


{-| Character state
-}
type State
    = Alive
    | Dead


{-| Core data structure for the enemy
-}
type alias Self =
    { x : Float
    , y : Float
    , hp : Float
    , id : Int
    , state : State
    , career : String
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    Self


{-| Empty init data for enemy
-}
emptyInitData : InitData
emptyInitData =
    { x = 800
    , y = 100
    , hp = 100
    , id = 1
    , state = Alive
    , career = "magician"
    }
