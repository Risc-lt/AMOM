module Scenes.SampleScene.Model exposing (scene)

{-|


# Level configuration module

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env)
import Messenger.Scene.RawScene exposing (RawSceneProtoLevelInit)
import Messenger.Scene.Scene exposing (SceneStorage)
import SceneProtos.Story.Components.Background.Model as Background
import SceneProtos.Story.Components.Bithif.Model as Bithif
import SceneProtos.Story.Components.Bruce.Model as Bruce
import SceneProtos.Story.Components.Bulingze.Model as Bulingze
import SceneProtos.Story.Components.Wenderd.Model as Wenderd
import SceneProtos.Story.Components.ComponentBase exposing (ComponentMsg(..))
import SceneProtos.Story.Components.Dialogue.Model as Dialogue
import SceneProtos.Story.Init exposing (InitData)
import SceneProtos.Story.Model exposing (genScene)
import MainConfig exposing (background)


init : RawSceneProtoLevelInit UserData SceneMsg (InitData SceneMsg)
init env msg =
    Just (initData env msg)

initData : Env () UserData -> Maybe SceneMsg -> InitData SceneMsg
initData env msg = { objects =
        [ 
        ]
    , order = "1"
    }

{-| Scene storage
-}
scene : SceneStorage UserData SceneMsg
scene =
    genScene init
