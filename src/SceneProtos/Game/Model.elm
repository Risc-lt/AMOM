module SceneProtos.Game.Model exposing (genScene)

{-| Scene configuration module

@docs genScene

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, addCommonData)
import Messenger.Scene.LayeredScene exposing (LayeredSceneLevelInit, LayeredSceneProtoInit, LayeredSceneSettingsFunc, genLayeredScene, initCompose)
import Messenger.Scene.Scene exposing (SceneStorage)
import SceneProtos.Game.Init exposing (InitData)
import SceneProtos.Game.Play.Model as Play
import SceneProtos.Game.SceneBase exposing (..)


commonDataInit : Env () UserData -> Maybe (InitData SceneMsg) -> SceneCommonData
commonDataInit _ _ =
    { gameover = False }


init : LayeredSceneProtoInit SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg (InitData SceneMsg)
init env data =
    let
        cd =
            commonDataInit env data

        envcd =
            addCommonData cd env

        comps =
            List.map (\x -> x envcd)
                (case data of
                    Just d ->
                        d.objects

                    Nothing ->
                        []
                )
    in
    { renderSettings = []
    , commonData = cd
    , layers =
        [ Play.layer (PlayInitData { components = comps }) envcd
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
