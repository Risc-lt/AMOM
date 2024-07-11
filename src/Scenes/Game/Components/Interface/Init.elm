module Scenes.Game.Components.Interface.Init exposing
    ( InitData
    , Chars, Type(..), defaultChars, defaultUI, emptyInitData
    )

{-|


# Init module

@docs InitData

-}


{-| Character types
-}
type Type
    = Enemy
    | Self


{-| Core data structure for the characters
-}
type alias Chars =
    { hp : Float
    , side : Type
    , position : Int
    , name : String
    }


{-| The data used to initialize the interface
-}
type alias InitData =
    { chars : List Chars
    }


{-| Empty init data for allies
-}
emptyInitAlly : List Chars
emptyInitAlly =
    [ { hp = 100
      , side = Self
      , position = 1
      , name = "Wenderd"
      }
    , { hp = 100
      , side = Self
      , position = 2
      , name = "Bruce"
      }
    , { hp = 100
      , side = Self
      , position = 4
      , name = "Bulingze"
      }
    , { hp = 100
      , side = Self
      , position = 5
      , name = "Bithif"
      }
    ]


{-| Empty init data for enemies
-}
emptyInitEnemy : List Chars
emptyInitEnemy =
    [ { hp = 100
      , side = Enemy
      , position = 1
      , name = "Monster"
      }
    , { hp = 100
      , side = Enemy
      , position = 2
      , name = "Monster"
      }
    , { hp = 100
      , side = Enemy
      , position = 4
      , name = "Monster"
      }
    , { hp = 100
      , side = Enemy
      , position = 5
      , name = "Monster"
      }
    ]


{-| Empty init data for interface
-}
emptyInitData : InitData
emptyInitData =
    { chars = emptyInitAlly ++ emptyInitEnemy }


{-| Default character
-}
defaultChars : Chars
defaultChars =
    { hp = 0
    , side = Self
    , position = 1
    , name = ""
    }


{-| Default interface
-}
defaultUI : InitData
defaultUI =
    { chars = [ defaultChars ]
    }
