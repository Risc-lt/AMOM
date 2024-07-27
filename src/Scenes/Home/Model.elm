module Scenes.Home.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Canvas
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Duration
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (UserEvent(..))
import Messenger.GlobalComponents.Transition.Transitions.Base exposing (genTransition)
import Messenger.GlobalComponents.Transition.Transitions.Fade exposing (fadeInBlack, fadeOutBlack)
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithStyle)
import Messenger.Scene.RawScene exposing (RawSceneInit, RawSceneUpdate, RawSceneView, genRawScene)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneOutputMsg(..), SceneStorage)
import Scenes.Begin.Model exposing (scene)
import Scenes.Home.Init exposing (Data, Direction(..), getNext, getX, initData)
import String exposing (right)


init : RawSceneInit Data UserData SceneMsg
init env msg =
    initData


update : RawSceneUpdate Data UserData SceneMsg
update env msg data =
    case msg of
        MouseDown _ ( x, y ) ->
            if x > 850 && x < 1060 && y > 430 && y < 580 then
                ( data, [ SOMChangeScene Nothing (getNext data.curScene data.sceneQueue) ], env )

            else if x > 1800 && x < 1900 && y > 1000 && y < 1100 then
                if data.curScene < 9 then
                    ( { data | direction = Right }, [], env )

                else
                    ( data, [], env )

            else if x > 0 && x < 100 && y > 1000 && y < 1100 then
                if data.curScene > 1 then
                    ( { data | direction = Left }, [], env )

                else
                    ( data, [], env )

            else
                ( data, [], env )

        Tick _ ->
            case data.direction of
                Right ->
                    if data.left >= getX (data.curScene + 1) data.sceneQueue - 720 then
                        ( { data | direction = Null, curScene = data.curScene + 1 }, [], env )

                    else
                        ( { data | left = data.left + 100 }, [], env )

                Left ->
                    if data.left <= getX (data.curScene - 1) data.sceneQueue - 720 then
                        ( { data | direction = Null, curScene = data.curScene - 1 }, [], env )

                    else
                        ( { data | left = data.left - 100 }, [], env )

                Null ->
                    ( data, [], env )

        _ ->
            ( data, [], env )


view : RawSceneView UserData Data
view env data =
    let
        basicView =
            [ renderSprite env.globalData.internalData [] ( 0, 0 ) ( 1920, 1080 ) "background"
            , Canvas.shapes
                [ fill (Color.rgba 0 0 0 0.7) ]
                [ rect env.globalData.internalData ( 1800, 1000 ) ( 100, 100 ) ]
            , Canvas.shapes
                [ fill (Color.rgba 0 0 0 0.7) ]
                [ rect env.globalData.internalData ( 0, 1000 ) ( 100, 100 ) ]
            ]

        sceneView =
            List.map
                (\scenePic ->
                    if scenePic.id == data.curScene then
                        renderSprite env.globalData.internalData [] ( scenePic.x - data.left - 50, scenePic.y - 50 ) ( scenePic.w + 100, scenePic.h + 100 ) scenePic.name

                    else
                        renderSprite env.globalData.internalData [] ( scenePic.x - data.left, scenePic.y ) ( scenePic.w, scenePic.h ) scenePic.name
                )
                data.sceneQueue

        textView =
            let
                content =
                    case List.head (List.filter (\scenePic -> scenePic.id == data.curScene) data.sceneQueue) of
                        Just scenePic ->
                            scenePic.text

                        Nothing ->
                            ""
            in
            renderTextWithColorCenter env.globalData.internalData 40 content "Arial" Color.black ( 970, 900 )
    in
    Canvas.group []
        (basicView ++ sceneView ++ [ textView ])


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
