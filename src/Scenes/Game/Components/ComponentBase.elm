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

import Json.Decode exposing (string)
import SceneProtos.Story.Components.ComponentBase exposing (ComponentMsg(..))
import SceneProtos.Story.Components.Dialogue.Init exposing (CreateInitData)
import Scenes.Game.Components.Dialogue.Init as DialogueMsg
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.GenAttributes exposing (..)
import Scenes.Game.Components.Interface.Init as InterfaceMsg
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.Components.Special.Init exposing (Skill)
import Scenes.Game.Components.StoryTrigger.Init exposing (TriggerConditions)


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
    | UIInit InterfaceMsg.InitData
    | InitDialogueMsg DialogueMsg.InitData
    | TriggerInit (List TriggerConditions)


type StatusMsg
    = ChangeSelfs (List Self)
    | ChangeEnemies (List Enemy)
    | ChangeBase BaseData
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
    | NewRound
    | ChangeStatus StatusMsg
    | GameOver
    | BeginDialogue Int
    | CloseDialogue
    | CheckIsTriggered (List TriggerConditions)
    | Defeated
    | AddChar
    | NullComponentMsg


type alias ComponentTarget =
    String


type Gamestate
    = GameBegin
    | PlayerTurn
    | PlayerAttack Bool
    | ChooseSpeSkill
    | ChooseMagic
    | ChooseItem
    | Compounding
    | TargetSelection ActionType
    | PlayerReturn Bool
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
    , isStopped : Bool
    }


initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyNum = [ 7, 8, 9, 10, 11, 12 ]
    , selfNum = [ 1, 2, 4, 5 ]
    , curSelf = 0
    , curEnemy = 0
    , side = PlayerSide
    , isStopped = False
    }
