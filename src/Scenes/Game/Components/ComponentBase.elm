module Scenes.Game.Components.ComponentBase exposing
    ( AttackType(..)
    , BaseData
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
    = EnemyInit (List Enemy)
    | SelfInit (List Self)
    | Attack AttackType Int
    | SwitchTurn
    | GameOver
    | Defeated
    | NullComponentMsg


type AttackType
    = Physical
    | Magical


type alias ComponentTarget =
    String


type Gamestate
    = GameBegin
    | PlayerTurn
    | PlayerReturn
    | EnemyMove
    | EnemyAttack
    | EnemyReturn


type alias BaseData =
    { state : Gamestate
    , enemyHP : Float
    , selfHP : Float
    , curChar : Int
    , curEnemy : Int
    }


initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyHP = 100
    , selfHP = 100
    , curChar = 1
    , curEnemy = 1
    }
