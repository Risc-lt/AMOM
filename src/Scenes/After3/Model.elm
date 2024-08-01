module Scenes.After3.Model exposing (..)

{-|


# Level configuration module

This module contains the configuration for the level.

@docs scene

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (Env)
import Messenger.Scene.RawScene exposing (RawSceneProtoLevelInit, RawSceneUpdate, RawSceneView)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneOutputMsg(..), SceneStorage)
import SceneProtos.Story.Components.Background.Model as Background
import SceneProtos.Story.Components.CharSequence.Model as Character
import SceneProtos.Story.Components.ComponentBase exposing (ComponentMsg(..))
import SceneProtos.Story.Components.DialogSequence.Model as Dialogue
import SceneProtos.Story.Components.Trigger.Model as Trigger
import SceneProtos.Story.Init exposing (InitData)
import SceneProtos.Story.Model exposing (genScene)
import Scenes.After3.Background exposing (backgroundInitData)
import Scenes.After3.Characters exposing (charInitData)
import Scenes.After3.Dialogues exposing (dialogueInitData)


type alias Data =
    {}


init : RawSceneProtoLevelInit UserData SceneMsg (InitData SceneMsg)
init env msg =
    Just (initData env msg)


initData : Env () UserData -> Maybe SceneMsg -> InitData SceneMsg
initData env msg =
    let
        backgroundInit =
            backgroundInitData

        charInit =
            charInitData

        dialogueInit =
            dialogueInitData
    in
    { objects =
        [ Background.component (BackgroundInit <| backgroundInit)
        , Character.component (CharInit <| charInit)
        , Dialogue.component (DialogueInit <| dialogueInit)
        , Trigger.component (TriggerInit <| 2)
        ]
    , level = "After3"
    }



{- update : RawSceneUpdate Data UserData SceneMsg
   update env msg data =
       if env.globalData.sceneStartFrame == 0 then
           ( data, [ SOMPlayAudio 0 "opening" (ALoop Nothing Nothing) ], env )

       else
           ( data, [], env )


   view : RawSceneView UserData Data
   view env data =
       Canvas.empty


   scenecon : MConcreteScene Data UserData SceneMsg
   scenecon =
       { init = init
       , update = update
       , view = view
       }

-}


{-| Scene storage
-}
scene : SceneStorage UserData SceneMsg
scene =
    genScene init
