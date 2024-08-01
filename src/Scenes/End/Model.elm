module Scenes.End.Model exposing (scene)

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
import Messenger.Render.Text exposing (renderTextWithColorCenter)
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
        KeyDown key ->
            if key == 27 then
                ( data
                , [ SOMLoadGC
                        (genGC
                            (InitOption
                                (genTransition
                                    ( fadeOutBlack, Duration.seconds 1 )
                                    ( fadeInBlack, Duration.seconds 1 )
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
        [ Canvas.shapes
            [ fill (Color.rgba 255 255 0 0.1) ]
            [ rect env.globalData.internalData ( 0, 0 ) ( 1920, 1080 ) ]
        , renderTextWithColorCenter env.globalData.internalData 60 "Thank you" "Comic Sans MS" Color.black ( 1580, 420 )
        , renderTextWithColorCenter env.globalData.internalData 60 "for" "Comic Sans MS" Color.black ( 1580, 520 )
        , renderTextWithColorCenter env.globalData.internalData 60 "playing our game!" "Comic Sans MS" Color.black ( 1580, 620 )
        , renderSprite env.globalData.internalData [] ( 200, 150 ) ( 1000, 800 ) "logo"
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
