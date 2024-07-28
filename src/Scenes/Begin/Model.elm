module Scenes.Begin.Model exposing (..)

{-| Scene configuration module

@docs scene

-}

import Canvas
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Duration
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (UserEvent(..))
import Messenger.GlobalComponents.Transition.Transitions.Base exposing (genTransition)
import Messenger.GlobalComponents.Transition.Transitions.Fade exposing (fadeInBlack, fadeOutBlack)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Scene.RawScene exposing (RawSceneInit, RawSceneUpdate, RawSceneView, genRawScene)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneOutputMsg(..), SceneStorage)


type alias Data =
    {}


init : RawSceneInit Data UserData SceneMsg
init env msg =
    {}


update : RawSceneUpdate Data UserData SceneMsg
update env msg data =
    case msg of
        MouseDown _ ( x, y ) ->
            if x > 860 && x < 1050 && y > 450 && y < 515 then
                ( data, [ SOMChangeScene Nothing "Home" ], env )

            else if x > 860 && x < 1050 && y > 540 && y < 595 then
                ( data, [ SOMChangeScene Nothing "Instruction" ], env )

            else
                ( data, [], env )

        _ ->
            ( data, [], env )


view : RawSceneView UserData Data
view env data =
    Canvas.group []
        [ renderSprite env.globalData.internalData [] ( 0, 0 ) ( 1920, 1080 ) "begin"
        , renderSprite env.globalData.internalData [] ( 860, 450 ) ( 190, 65 ) "button_1"
        , renderSprite env.globalData.internalData [] ( 860, 540 ) ( 190, 55 ) "button_2"
        ]


scenecon : MConcreteScene Data UserData SceneMsg
scenecon =
    { init = init
    , update = update
    , view = view
    }


{-| Scene generator
-}
scene : SceneStorage UserData SceneMsg
scene =
    genRawScene scenecon
