module Scenes.Level3.Model exposing (scene)

{-|


# Level configuration module

This module contains all level configuration data for Level3 scene

@docs scene

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (Env)
import Messenger.Scene.RawScene exposing (RawSceneProtoLevelInit)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..), SceneStorage)
import SceneProtos.Game.Components.ComponentBase exposing (ComponentMsg(..), InitMsg(..))
import SceneProtos.Game.Components.Dialogue.Model as Dia
import SceneProtos.Game.Components.Enemy.Model as Enemy
import SceneProtos.Game.Components.Interface.Init as UIMsg
import SceneProtos.Game.Components.Interface.Model as UI
import SceneProtos.Game.Components.Self.Model as Self
import SceneProtos.Game.Components.StoryTrigger.Model as STri
import SceneProtos.Game.Init exposing (InitData)
import SceneProtos.Game.Model exposing (genScene)
import Scenes.Level3.Characters exposing (enemyInitData, selfInitData)
import Scenes.Level3.Plots exposing (dialogueInitData, triggerInitData)
import Time


type alias Data =
    {}


init : RawSceneProtoLevelInit UserData SceneMsg (InitData SceneMsg)
init env msg =
    Just (initData env msg)


initData : Env () UserData -> Maybe SceneMsg -> InitData SceneMsg
initData env msg =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        enemyInit =
            enemyInitData <| time

        selfInit =
            selfInitData <| time

        uiInit =
            UIMsg.emptyInitData selfInit enemyInit
    in
    { objects =
        [ Enemy.component (Init <| EnemyInit <| enemyInit)
        , Self.component (Init <| SelfInit <| selfInit)
        , UI.component (Init <| UIInit <| { uiInit | levelNum = 3 })
        , Dia.component (Init <| InitDialogueMsg <| dialogueInitData)
        , STri.component (Init <| TriggerInit <| triggerInitData)
        ]
    , level = "Level3"
    }


{-| Scene storage
-}
scene : SceneStorage UserData SceneMsg
scene =
    genScene init
