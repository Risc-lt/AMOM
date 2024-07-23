module Scenes.Game.Components.Interface.Init exposing
    ( InitData
    , defaultUI, emptyInitData
    )

{-|


# Init module

@docs InitData

-}

import Scenes.Game.Components.Enemy.Init as EnemyMsg exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.Self.Init as SelfMsg exposing (Self, defaultSelf)


{-| The data used to initialize the interface
-}
type alias InitData =
    { selfs : List Self
    , enemies : List Enemy
    }


{-| Empty init data for interface
-}
emptyInitData : List Self -> List Enemy -> InitData
emptyInitData selfInit enemyInit =
    { selfs = selfInit
    , enemies = enemyInit
    }


{-| Default interface
-}
defaultUI : InitData
defaultUI =
    { selfs = [ defaultSelf ]
    , enemies = [ defaultEnemy ]
    }
