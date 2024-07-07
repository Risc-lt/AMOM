module Scenes.Game.Components.Self.Init exposing
    ( InitData
    , Self, State(..), defaultSelf, emptyInitData
    )

{-|


# Init module

@docs InitData

-}


{-| Character state
-}
type State
    = Working
    | Waiting
    | Dead


{-| Core data structure for the self
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
    List Self


{-| Empty init data for self
-}
emptyInitData : InitData
emptyInitData =
    [ { x = 800
      , y = 100
      , hp = 100
      , id = 1
      , state = Waiting
      , career = "magician"
      }
    ]


{-| The default data for the self
-}
defaultSelf : Self
defaultSelf =
    { x = 800
    , y = 100
    , hp = 100
    , id = 1
    , state = Waiting
    , career = "magician"
    }
