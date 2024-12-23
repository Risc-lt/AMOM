module SceneProtos.Story.StoryLayer.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Canvas
import Color
import Duration exposing (Duration)
import Lib.Base exposing (SceneMsg)
import Lib.Resources exposing (resources)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioTarget(..))
import Messenger.Component.Component exposing (AbstractComponent, updateComponents, updateComponentsWithBlock, updateComponentsWithTarget, viewComponents)
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.GlobalComponents.Transition.Model exposing (genSequentialTransitionSOM)
import Messenger.GlobalComponents.Transition.Transitions.Base exposing (genTransition)
import Messenger.GlobalComponents.Transition.Transitions.Fade exposing (fadeIn, fadeInBlack, fadeOut, fadeOutBlack)
import Messenger.Layer.Layer exposing (ConcreteLayer, Handler, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer, handleComponentMsgs)
import Messenger.Layer.LayerExtra exposing (BasicUpdater, Distributor)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (..)


type alias Data =
    { components : List (AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg)
    }


init : LayerInit SceneCommonData UserData (LayerMsg SceneMsg) Data
init env initMsg =
    case initMsg of
        StoryLayerInitData data ->
            Data data.components

        _ ->
            Data []


handleComponentMsg : Handler Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg ComponentMsg
handleComponentMsg env compmsg data =
    case compmsg of
        SOMMsg som ->
            ( data, [ Parent <| SOMMsg som ], env )

        OtherMsg Over ->
            let
                nextScene =
                    case env.globalData.currentScene of
                        "Before1" ->
                            "Level1"

                        "Before2" ->
                            "Level2"

                        "Before3" ->
                            "Level3"

                        "After1" ->
                            "Before2"

                        "After2" ->
                            "Before3"

                        "After3" ->
                            "After4"

                        _ ->
                            "End"

                color =
                    if nextScene == "After4" then
                        Color.white

                    else
                        Color.black
            in
            ( data
            , [ Parent <|
                    SOMMsg <|
                        genSequentialTransitionSOM
                            ( fadeOut color, Duration.seconds 1.5 )
                            ( fadeIn color, Duration.seconds 1.5 )
                            ( nextScene, Nothing )
              ]
            , env
            )

        _ ->
            ( data, [], env )


updateBasic : BasicUpdater Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
updateBasic env evt data =
    ( data, [], ( env, False ) )


update : LayerUpdate SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
update env evt data =
    if env.globalData.sceneStartFrame == 0 then
        ( data, [ Parent <| SOMMsg <| SOMStopAudio AllAudio ], ( env, False ) )

    else
        let
            ( data1, lmsg1, ( env1, block1 ) ) =
                updateBasic env evt data

            ( comps1, cmsgs1, ( env2, block2 ) ) =
                updateComponentsWithBlock env1 evt block1 data1.components

            ( data2, ( lmsg2, tocmsg ), env3 ) =
                ( { data1 | components = comps1 }, ( [], [] ), env2 )

            ( comps2, cmsgs2, env4 ) =
                updateComponentsWithTarget env3 tocmsg data2.components

            ( data3, lmsgs3, env5 ) =
                handleComponentMsgs env4 (cmsgs2 ++ cmsgs1) { data2 | components = comps2 } (lmsg1 ++ lmsg2) handleComponentMsg
        in
        ( data3, lmsgs3, ( env5, block2 ) )



--else
--( data, [], ( env, False ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
updaterec env msg data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    Canvas.group
        []
        [ viewComponents env data.components
        ]


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "StoryLayer"


layercon : ConcreteLayer Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
layercon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Layer generator
-}
layer : LayerStorage SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
layer =
    genLayer layercon
