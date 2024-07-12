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


{-| Core data structure for the self
-}
type alias Self =
    { x : Float
    , y : Float
    , hp : Float
    , position : Int
    , state : State
    , career : String
    , phyDefence : Float
    , magDefence : Float
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    List Self


{-| Empty init data for self
-}
emptyInitData : InitData
emptyInitData =
    [ { x = 1100
      , y = 160
      , hp = 100
      , position = 1
      , state = Waiting
      , career = "swordsman"
      , phyDefence = 50
      , magDefence = 0
      }
    , { x = 1100
      , y = 290
      , hp = 100
      , position = 2
      , state = Waiting
      , career = "archer"
      , phyDefence = 50
      , magDefence = 0
      }
    , { x = 1100
      , y = 420
      , hp = 0
      , position = 3
      , state = Waiting
      , career = ""
      , phyDefence = 0
      , magDefence = 0
      }
    , { x = 1220
      , y = 160
      , hp = 100
      , position = 4
      , state = Waiting
      , career = "magician"
      , phyDefence = 0
      , magDefence = 50
      }
    , { x = 1220
      , y = 290
      , hp = 100
      , position = 5
      , state = Waiting
      , career = "pharmacist"
      , phyDefence = 0
      , magDefence = 50
      }
    , { x = 1220
      , y = 420
      , hp = 0
      , position = 6
      , state = Waiting
      , career = ""
      , phyDefence = 0
      , magDefence = 0
      }
    ]


{-| The default data for the self
-}
defaultSelf : Self
defaultSelf =
    { x = 0
    , y = 0
    , hp = 0
    , position = 1
    , state = Waiting
    , career = ""
    , phyDefence = 0
    , magDefence = 0
    }
