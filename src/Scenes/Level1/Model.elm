module Scenes.Level1.Model exposing (scene)

{-|


# Level configuration module

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env)
import Messenger.Scene.RawScene exposing (RawSceneProtoLevelInit)
import Messenger.Scene.Scene exposing (SceneStorage)
import SceneProtos.Game.Components.Dialogue.Init as DiaMsg
import SceneProtos.Game.Components.Dialogue.Model as Dia
import SceneProtos.Game.Components.Enemy.Init as EnemyMsg
import SceneProtos.Game.Components.Enemy.Model as Enemy
import SceneProtos.Game.Components.Self.Init as SelfMsg
import SceneProtos.Game.Components.Self.Model as Self
import SceneProtos.Game.Components.StoryTrigger.Init as STriMsg
import SceneProtos.Game.Components.StoryTrigger.Model as STri
import SceneProtos.Game.Init exposing (InitData)
import SceneProtos.Game.Model exposing (genScene)
import SceneProtos.Game.Components.Interface.Init as UIMsg
import SceneProtos.Game.Components.Interface.Model as UI
import SceneProtos.Game.Components.ComponentBase exposing (ComponentMsg(..), InitMsg(..))
import Time


init : RawSceneProtoLevelInit UserData SceneMsg (InitData SceneMsg)
init env msg =
    Just (initData env msg)


initData : Env () UserData -> Maybe SceneMsg -> InitData SceneMsg
initData env msg =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        enemyInit =
            EnemyMsg.emptyInitData <| time

        selfInit =
            SelfMsg.emptyInitData <| time
    in
    { objects =
        [ Enemy.component (Init <| EnemyInit <| enemyInit)
        , Self.component (Init <| SelfInit <| selfInit)
        , UI.component (Init <| UIInit <| UIMsg.emptyInitData selfInit enemyInit)
        , Dia.component (Init <| InitDialogueMsg <| DiaMsg.emptyInitData)
        , STri.component (Init <| TriggerInit <| STriMsg.emptyInitData)
        ]
    , level = "Level1"
    }


{-| Scene storage
-}
scene : SceneStorage UserData SceneMsg
scene =
    genScene init
