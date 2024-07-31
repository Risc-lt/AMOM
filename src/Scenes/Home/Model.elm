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
import Messenger.GlobalComponents.Transition.Model exposing (InitOption, genGC)
import Messenger.GlobalComponents.Transition.Transitions.Base exposing (genTransition)
import Messenger.GlobalComponents.Transition.Transitions.Fade exposing (fadeInBlack, fadeOutBlack)
import Messenger.Render.Shape exposing (circle, rect)
import Messenger.Render.Sprite exposing (renderSprite, renderSpriteWithRev)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithStyle)
import Messenger.Scene.RawScene exposing (RawSceneInit, RawSceneUpdate, RawSceneView, genRawScene)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneOutputMsg(..), SceneStorage)
import Scenes.Begin.Model exposing (scene)
import Scenes.Home.Init exposing (Data, Direction(..), get, initData)
import String exposing (right)


init : RawSceneInit Data UserData SceneMsg
init env msg =
    initData


update : RawSceneUpdate Data UserData SceneMsg
update env msg data =
    case msg of
        MouseDown _ ( x, y ) ->
            let
                ( _, next ) =
                    get data.curScene data.sceneQueue
            in
            if x > 850 && x < 1060 && y > 430 && y < 580 then
                ( data
                , [ SOMLoadGC
                        (genGC
                            (InitOption
                                (genTransition
                                    ( fadeOutBlack, Duration.seconds 2 )
                                    ( fadeInBlack, Duration.seconds 2 )
                                    Nothing
                                )
                                ( next, Nothing )
                                True
                            )
                            Nothing
                        )
                  ]
                , env
                )

            else if x > 1450 && x < 1550 && y > 880 && y < 980 then
                if data.curScene < 9 then
                    ( { data | direction = Right }, [], env )

                else
                    ( data, [], env )

            else if x > 400 && x < 500 && y > 880 && y < 980 then
                if data.curScene > 1 then
                    ( { data | direction = Left }, [], env )

                else
                    ( data, [], env )

            else
                ( data, [], env )

        Tick _ ->
            case data.direction of
                Right ->
                    let
                        ( pos, _ ) =
                            get (data.curScene + 1) data.sceneQueue
                    in
                    if data.left >= pos - 720 then
                        ( { data | direction = Null, curScene = data.curScene + 1 }, [], env )

                    else
                        ( { data | left = data.left + 100 }, [], env )

                Left ->
                    let
                        ( pos, _ ) =
                            get (data.curScene - 1) data.sceneQueue
                    in
                    if data.left <= pos - 720 then
                        ( { data | direction = Null, curScene = data.curScene - 1 }, [], env )

                    else
                        ( { data | left = data.left - 100 }, [], env )

                Null ->
                    ( data, [], env )

        _ ->
            ( data, [], env )


renderBasicView : RawSceneView UserData Data
renderBasicView env data =
    let
        ( x, y ) =
            env.globalData.mousePos

        button =
            if x > 1450 && x < 1550 && y > 880 && y < 980 then
                [ renderSprite env.globalData.internalData [] ( 1446, 875 ) ( 120, 120 ) "arrow"
                , renderSpriteWithRev True env.globalData.internalData [] ( 398, 883 ) ( 100, 100 ) "arrow"
                ]

            else if x > 400 && x < 500 && y > 880 && y < 980 then
                [ renderSpriteWithRev True env.globalData.internalData [] ( 390, 875 ) ( 120, 120 ) "arrow"
                , renderSprite env.globalData.internalData [] ( 1453, 883 ) ( 100, 100 ) "arrow"
                ]

            else
                [ renderSprite env.globalData.internalData [] ( 1453, 883 ) ( 100, 100 ) "arrow"
                , renderSpriteWithRev True env.globalData.internalData [] ( 398, 883 ) ( 100, 100 ) "arrow"
                ]
    in
    Canvas.group []
        ([ renderSprite env.globalData.internalData [] ( 0, 0 ) ( 1920, 1080 ) "levelselect"
         , Canvas.shapes
            [ fill (Color.rgba 0 0 0 0.7) ]
            [ circle env.globalData.internalData ( 1500, 930 ) 50 ]
         , Canvas.shapes
            [ fill (Color.rgba 0 0 0 0.7) ]
            [ circle env.globalData.internalData ( 450, 930 ) 50 ]
         ]
            ++ button
        )


view : RawSceneView UserData Data
view env data =
    let
        basicView =
            renderBasicView env data

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
            Canvas.group []
                [ Canvas.shapes
                    [ fill (Color.rgba 0 0 0 0.7) ]
                    [ rect env.globalData.internalData ( 500, 850 ) ( 950, 150 ) ]
                , renderTextWithColorCenter env.globalData.internalData 40 content "Comic Sans MS" Color.white ( 970, 925 )
                ]
    in
    Canvas.group []
        ([ basicView, textView ] ++ sceneView)


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
