module SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)

{-|


# Component base

@docs ActionMsg, ActionSide, ActionType, BaseData, ComponentMsg, ComponentTarget, Gamestate, InitMsg, StatusMsg, initBaseData

-}

import Json.Decode exposing (string)
import SceneProtos.Game.Components.Dialogue.Init as DialogueMsg
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.GenAttributes exposing (..)
import SceneProtos.Game.Components.Interface.Init as InterfaceMsg
import SceneProtos.Game.Components.Self.Init exposing (Self)
import SceneProtos.Game.Components.Special.Init exposing (Buff, Skill)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions)
import SceneProtos.Story.Components.ComponentBase exposing (ComponentMsg(..))


{-| Init message for component
-}
type InitMsg
    = EnemyInit (List Enemy)
    | SelfInit (List Self)
    | UIInit InterfaceMsg.InitData
    | InitDialogueMsg DialogueMsg.InitData
    | TriggerInit (List ( TriggerConditions, Int ))


{-| Status message for component
-}
type StatusMsg
    = ChangeSelfs (List Self)
    | ChangeEnemies (List Enemy)
    | ChangeBase BaseData
    | ChangeState Gamestate


{-| Action type for component
-}
type ActionType
    = Attack
    | Skills Skill


{-| Action message for component
-}
type ActionMsg
    = PlayerNormal Self Int
    | EnemyNormal Enemy Int
    | StartCounter
    | PlayerSkill Self Skill Int
    | EnemySkill Enemy Skill Int


{-| Component message for component
-}
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
    | CheckIsTriggered (List ( TriggerConditions, Int ))
    | Defeated Bool
    | AddChar
    | PutBuff Buff Int
    | NullComponentMsg


{-| Component target for component
-}
type alias ComponentTarget =
    String


{-| Game state for component
-}
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


{-| Action side for component
-}
type ActionSide
    = PlayerSide
    | EnemySide
    | Undeclaced


{-| Base data for component
-}
type alias BaseData =
    { state : Gamestate
    , enemyNum : List Int
    , selfNum : List Int
    , curSelf : Int
    , curEnemy : Int
    , side : ActionSide
    , isStopped : Bool
    , timestamp : Int
    }


{-| Initial base data for component
-}
initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyNum = [ 7, 8, 9, 10, 11, 12 ]
    , selfNum = [ 1, 2, 3, 4, 5, 6 ]
    , curSelf = 0
    , curEnemy = 0
    , side = PlayerSide
    , isStopped = False
    , timestamp = 1
    }
