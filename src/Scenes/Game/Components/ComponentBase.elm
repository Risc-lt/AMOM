module Scenes.Game.Components.ComponentBase exposing
    ( BaseData
    , ComponentMsg(..)
    , ComponentTarget
    , Gamestate(..)
    , initBaseData
    )

import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Self.Init exposing (Self)


{-|


# Component base

@docs ComponentMsg: Component message
@docs ComponentTarget: Component target
@docs GamState: Record of whose turn it is
@docs BaseData: Component base data
@docs initBaseData: Initial base data

-}
type ComponentMsg
    = EnemyInit Enemy
    | SelfInit Self
    | PhysicalAttack Int
    | ReturnPlace
    | GameOver
    | Defeated
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
    , enemyHP : Float
    , selfHP : Float
    }


initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyHP = 100
    , selfHP = 100
    }
