module Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)

import Scenes.Game.Components.Enemy.Init exposing (Enemy)


{-|


# Component base

@docs ComponentMsg: Component message
@docs ComponentTarget: Component target
@docs BaseData: Component base data

-}
type ComponentMsg
    = EnemyInit Enemy
    | NullComponentMsg


type alias ComponentTarget =
    String


type alias BaseData =
    ()
