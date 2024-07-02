module Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)

import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Self.Init exposing (Self)


{-|


# Component base

@docs ComponentMsg: Component message
@docs ComponentTarget: Component target
@docs BaseData: Component base data

-}
type ComponentMsg
    = EnemyInit Enemy
    | SelfInit Self
    | NullComponentMsg


type alias ComponentTarget =
    String


type alias BaseData =
    ()
