module Scenes.Before2.Model exposing (scene)

{-|


# Level configuration module

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
import SceneProtos.Story.Components.Sommsg.Model as Sommsg
import SceneProtos.Story.Components.Trigger.Model as Trigger
import SceneProtos.Story.Init exposing (InitData)
import SceneProtos.Story.Model exposing (genScene)
import Scenes.Before2.Background exposing (backgroundInitData)
import Scenes.Before2.Characters exposing (charInitData)
import Scenes.Before2.Dialogues exposing (dialogueInitData)
import Scenes.Before2.Sommsgs exposing (sommsgInitData)


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

        sommsgInit =
            sommsgInitData
    in
    { objects =
        [ Background.component (BackgroundInit <| backgroundInit)
        , Character.component (CharInit <| charInit)
        , Dialogue.component (DialogueInit <| dialogueInit)
        , Sommsg.component (SommsgInit <| sommsgInit)
        , Trigger.component (TriggerInit <| 18)
        ]
    , level = "Before2"
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
