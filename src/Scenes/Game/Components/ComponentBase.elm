module Scenes.Game.Components.ComponentBase exposing
    ( ActionMsg(..)
    , ActionSide(..)
    , ActionType(..)
    , BaseData
    , ComponentMsg(..)
    , ComponentTarget
    , Gamestate(..)
    , InitMsg(..)
    , StatusMsg(..)
    , initBaseData
    )

import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.GenAttributes exposing (..)
import Scenes.Game.Components.Interface.Init exposing (InitData)
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.Components.Skill.Init exposing (Skill)


{-|


# Component base

@docs ComponentMsg: Component message
@docs ComponentTarget: Component target
@docs GamState: Record of whose turn it is
@docs BaseData: Component base data
@docs initBaseData: Initial base data

-}
type InitMsg
    = EnemyInit (List Enemy)
    | SelfInit (List Self)
    | UIInit InitData


type StatusMsg
    = ChangeSelfs (List Self)
    | ChangeEnemies (List Enemy)
    | ChangeState Gamestate


type ActionType
    = Attack
    | Skills Skill


type ActionMsg
    = PlayerNormal Self Int
    | EnemyNormal Enemy Int
    | StartCounter
    | PlayerSkill Self Skill Int
    | EnemySkill Enemy Skill Int


type ComponentMsg
    = Init InitMsg
    | Action ActionMsg
    | AttackSuccess Int
    | CharDie (List Int)
    | SwitchTurn Int
    | ChangeStatus StatusMsg
    | UpdateChangingPos (List Self)
    | StartGame
    | GameOver
    | Defeated
    | NullComponentMsg


type alias ComponentTarget =
    String


type Gamestate
    = GameBegin
    | PlayerTurn
    | PlayerAttack
    | ChooseSpeSkill
    | ChooseMagic
    | TargetSelection ActionType
    | PlayerReturn
    | EnemyTurn
    | EnemyAttack
    | EnemyReturn
    | Counter


type ActionSide
    = PlayerSide
    | EnemySide
    | Undeclaced


type alias BaseData =
    { state : Gamestate
    , enemyNum : List Int
    , selfNum : List Int
    , curSelf : Int
    , curEnemy : Int
    , side : ActionSide
    }


initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyNum = [ 7, 8, 9, 10, 11, 12 ]
    , selfNum = [ 1, 2, 4, 5 ]
    , curSelf = 0
    , curEnemy = 0
    , side = Undeclaced
    }
