module Scenes.Begin.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Canvas
import Duration
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (UserEvent(..))
import Messenger.GlobalComponents.Transition.Model exposing (InitOption, genGC)
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
        Tick _ ->
            if env.globalData.globalStartFrame == 120 then
                ( data
                , [ SOMLoadGC
                        (genGC
                            (InitOption
                                (genTransition
                                    ( fadeOutBlack, Duration.seconds 2 )
                                    ( fadeInBlack, Duration.seconds 2 )
                                    Nothing
                                )
                                ( "Home", Nothing )
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
        [ renderSprite env.globalData.internalData [] ( 0, 0 ) ( 1920, 1080 ) "begin"
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
