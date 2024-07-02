module Scenes.Game.Components.ComponentBase exposing (ComponentMsg(..), ComponentTarget, BaseData)

import Scenes.Game.Components.Enemy.Init exposing (Enemy)

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}


{-| Component message
-}
type ComponentMsg
    = EnemyInit Enemy
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
