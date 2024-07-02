module Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))

import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Self.Init exposing (Self)


{-|


# Component base

@docs ComponentMsg: Component message
@docs ComponentTarget: Component target
@docs BaseData: Component base data
@docs GamState

-}
type ComponentMsg
    = EnemyInit Enemy
    | SelfInit Self
    | PhysicalAttack Int
    | ReturnPlace
    | GameOver
    | NullComponentMsg


type alias ComponentTarget =
    String


type Gamestate
    = GameBegin
    | PlayerTurn
    | EnemyMove
    | EnemyAttack
    | EnemyReturn


type alias BaseData =
    { state : Gamestate
    }
