module SceneProtos.Story.Model exposing (genScene)

{-| Scene configuration module

@docs genScene

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, addCommonData)
import Messenger.Scene.LayeredScene exposing (LayeredSceneLevelInit, LayeredSceneProtoInit, LayeredSceneSettingsFunc, genLayeredScene, initCompose)
import Messenger.Scene.Scene exposing (SceneStorage)
import SceneProtos.Story.Init exposing (InitData)
import SceneProtos.Story.Main.Model as Main
import SceneProtos.Story.SceneBase exposing (..)
import SceneProtos.Story.Components.Background.Model as Background
import SceneProtos.Story.Components.Bithif.Model as Bithif
import SceneProtos.Story.Components.Dialogue.Model as Dialogue
import SceneProtos.Story.Components.Bruce.Model as Bruce
import SceneProtos.Story.Components.Bulingze.Model as Bulingze
import SceneProtos.Story.Components.Wenderd.Model as Wendered


commonDataInit : Env () UserData -> Maybe (InitData SceneMsg) -> SceneCommonData
commonDataInit _ _ =
    {}


init : LayeredSceneProtoInit SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg (InitData SceneMsg)
init env data =
    let
        cd =
            commonDataInit env data

        envcd =
            addCommonData cd env
    in
    { renderSettings = []
    , commonData = cd
    , layers =
        [ Main.layer NullLayerMsg envcd
        ]
    }


settings : LayeredSceneSettingsFunc SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
settings _ _ _ =
    []


{-| Scene generator
-}
genScene : LayeredSceneLevelInit UserData SceneMsg (InitData SceneMsg) -> SceneStorage UserData SceneMsg
genScene initd =
    genLayeredScene (initCompose init initd) settings
