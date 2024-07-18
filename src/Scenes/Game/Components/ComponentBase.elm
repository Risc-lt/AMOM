module Scenes.Game.Components.ComponentBase exposing
    ( ActionMsg(..)
    , ActionSide(..)
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
    | ChangeBase BaseData


type ActionMsg
    = PlayerNormal Self Int IsCounter
    | EnemyNormal Enemy Int IsCounter


type alias IsCounter =
    Bool


type ComponentMsg
    = Init InitMsg
    | Action ActionMsg
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
    | TargetSelection
    | PlayerReturn
    | EnemyMove
    | EnemyAttack
    | EnemyReturn


type ActionSide
    = PlayerSide
    | EnemySide
    | Undeclaced


type alias BaseData =
    { state : Gamestate
    , enemyNum : List Int
    , selfNum : List Int
    , curChar : Int
    , curEnemy : Int
    , queue : List Int
    , side : ActionSide
    }


initBaseData : BaseData
initBaseData =
    { state = GameBegin
    , enemyNum = [ 7, 8, 9, 10, 11, 12 ]
    , selfNum = [ 1, 2, 3, 4, 5, 6 ]
    , curChar = 1
    , curEnemy = 7
    , queue = []
    , side = Undeclaced
    }
