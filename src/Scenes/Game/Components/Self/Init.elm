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
    , position : Int
    , hp : Float
    , mp : Float
    , hpMax : Float
    , mpMax : Float
    , state : State
    , career : String
    , phyDefence : Float
    , magDefence : Float
    , attributes : Attribute
    }


{-| Additional attributes of the self
-}
type alias Attribute =
    { strength : Float
    , agility : Float
    , stamina : Float
    , spirit : Float
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    List Self


{-| Base attributes for the self
-}
baseAttributes : Attribute
baseAttributes =
    { strength = 10
    , agility = 10
    , stamina = 10
    , spirit = 10
    }


{-| Empty init data for self
-}
emptyInitData : InitData
emptyInitData =
    [ { x = 1100
      , y = 160
      , position = 1
      , hp = 100
      , mp = 3
      , hpMax = 100
      , mpMax = 3
      , state = Waiting
      , career = "swordsman"
      , phyDefence = 50
      , magDefence = 0
      , attributes = baseAttributes
      }
    , { x = 1100
      , y = 290
      , position = 2
      , hp = 100
      , mp = 3
      , hpMax = 100
      , mpMax = 3
      , state = Waiting
      , career = "archer"
      , phyDefence = 50
      , magDefence = 0
      , attributes = baseAttributes
      }
    , { x = 1100
      , y = 420
      , position = 3
      , hp = 0
      , mp = 3
      , hpMax = 100
      , mpMax = 3
      , state = Waiting
      , career = ""
      , phyDefence = 0
      , magDefence = 0
      , attributes = baseAttributes
      }
    , { x = 1220
      , y = 160
      , position = 4
      , hp = 100
      , mp = 3
      , hpMax = 100
      , mpMax = 3
      , state = Waiting
      , career = "magician"
      , phyDefence = 0
      , magDefence = 50
      , attributes = baseAttributes
      }
    , { x = 1220
      , y = 290
      , position = 5
      , hp = 100
      , mp = 3
      , hpMax = 100
      , mpMax = 3
      , state = Waiting
      , career = "pharmacist"
      , phyDefence = 0
      , magDefence = 50
      , attributes = baseAttributes
      }
    , { x = 1220
      , y = 420
      , position = 6
      , hp = 0
      , mp = 3
      , hpMax = 100
      , mpMax = 3
      , state = Waiting
      , career = ""
      , phyDefence = 0
      , magDefence = 0
      , attributes = baseAttributes
      }
    ]


{-| The default data for the self
-}
defaultSelf : Self
defaultSelf =
    { x = 0
    , y = 0
    , position = 1
    , hp = 0
    , mp = 3
    , hpMax = 100
    , mpMax = 3
    , state = Waiting
    , career = ""
    , phyDefence = 0
    , magDefence = 0
    , attributes = baseAttributes
    }
