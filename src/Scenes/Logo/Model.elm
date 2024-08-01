module Scenes.Logo.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Canvas
import Canvas.Settings exposing (fill)
import Color
import Duration
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (UserEvent(..))
import Messenger.GlobalComponents.Transition.Model exposing (InitOption, genGC)
import Messenger.GlobalComponents.Transition.Transitions.Base exposing (genTransition)
import Messenger.GlobalComponents.Transition.Transitions.Fade exposing (fadeInBlack, fadeOutBlack)
import Messenger.Render.Shape exposing (rect)
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
        Tick _ ->
            if env.globalData.globalStartFrame == 120 then
                ( data
                , [ SOMLoadGC
                        (genGC
                            (InitOption
                                (genTransition
                                    ( fadeOutBlack, Duration.seconds 1 )
                                    ( fadeInBlack, Duration.seconds 1 )
                                    Nothing
                                )
                                ( "Begin", Nothing )
                                True
                            )
                            Nothing
                        )
                  ]
                , env
                )

            else
                ( data, [], env )

        _ ->
            ( data, [], env )


view : RawSceneView UserData Data
view env data =
    Canvas.group []
        [ Canvas.shapes
            [ fill (Color.rgba 0 0 0 1) ]
            [ rect env.globalData.internalData ( 0, 0 ) ( 1920, 1080 ) ]
        , renderSprite env.globalData.internalData [] ( 560, 140 ) ( 800, 800 ) "logo"
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
