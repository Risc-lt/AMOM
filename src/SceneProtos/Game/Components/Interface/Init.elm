module SceneProtos.Game.Components.Interface.Init exposing
    ( InitData
    , defaultUI
    , emptyInitData
    )

{-|


# Init module

@docs InitData
@docs defaultUI
@docs emptyInitData

-}

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)


{-| The data used to initialize the interface
-}
type alias InitData =
    { selfs : List Self
    , enemies : List Enemy
    , queue : List Int
    , curIndex : Int
    , levelNum : Int
    }


{-| Empty init data for interface
-}
emptyInitData : List Self -> List Enemy -> InitData
emptyInitData selfInit enemyInit =
    { selfs = selfInit
    , enemies = enemyInit
    , queue = []
    , curIndex = 0
    , levelNum = 0
    }


{-| Default interface
-}
defaultUI : InitData
defaultUI =
    { selfs = [ defaultSelf ]
    , enemies = [ defaultEnemy ]
    , queue = []
    , curIndex = 0
    , levelNum = 0
    }
