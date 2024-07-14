module Scenes.Game.Components.ComponentBase exposing
    ( AttackType(..)
    , BaseData
    , ComponentMsg(..)
    , ComponentTarget
    , Gamestate(..)
    , initBaseData
    )

import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Interface.Init exposing (InitData)
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
    | UIInit InitData
    | AttackEnemy AttackType Self Int
    | AttackPlayer AttackType Enemy Int
    | ChangeTarget ( Int, Int )
    | EnemyDie (List Int)
    | SwitchTurn
    | ChangeSelfs (List Self)
    | ChangeEnemies (List Enemy)
    | ChangeBase BaseData
    | GameOver
    | Defeated
    | NullComponentMsg


type AttackType
    = NormalAttack
    | SpecialSkill
    | Magic


type alias ComponentTarget =
    String


type Gamestate
    = GameBegin
    | PlayerTurn
    | PlayerAttack
    | TargetSelection
    | PlayerReturn
    | EnemyMove
    | EnemyAttack
    | EnemyReturn


type alias BaseData =
    { state : Gamestate
    , enemyNum : List Int
    , selfNum : ( Int, Int )
    , curChar : Int
    , curEnemy : Int
    , queue : List Int
    }


initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyNum = [ 1, 2, 3, 4, 5, 6 ]
    , selfNum = ( 2, 2 )
    , curChar = 1
    , curEnemy = 1
    , queue = []
    }
