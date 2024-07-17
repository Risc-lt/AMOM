module Scenes.Game.Components.Interface.Init exposing
    ( InitData
    , Chars, defaultUI, emptyInitData
    )

{-|


# Init module

@docs InitData

-}

import Scenes.Game.Components.Enemy.Init as EnemyMsg exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.Self.Init as SelfMsg exposing (Self, defaultSelf)


{-| Core data structure for the characters
-}
type Chars
    = Self Self
    | Enemy Enemy


{-| The data used to initialize the interface
-}
type alias InitData =
    { selfs : List Self
    , enemies : List Enemy
    , curChar : Chars
    , charPointer : Int
    }


{-| Empty init data for allies
-}
emptyInitSelf : List Self
emptyInitSelf =
    SelfMsg.emptyInitData


{-| Empty init data for enemies
-}
emptyInitEnemy : List Enemy
emptyInitEnemy =
    EnemyMsg.emptyInitData


{-| Empty init data for interface
-}
emptyInitData : InitData
emptyInitData =
    { selfs = emptyInitSelf
    , enemies = emptyInitEnemy
    , curChar = Self { defaultSelf | position = 0 }
    , charPointer = 1
    }


{-| Default interface
-}
defaultUI : InitData
defaultUI =
    { selfs = emptyInitSelf
    , enemies = emptyInitEnemy
    , curChar = Self { defaultSelf | position = 0 }
    , charPointer = 1
    }
