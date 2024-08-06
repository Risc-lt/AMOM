module SceneProtos.Game.Play.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Canvas exposing (lineTo, moveTo, path)
import Canvas.Settings exposing (fill, stroke)
import Color
import Duration exposing (Duration)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..), AudioTarget(..))
import Messenger.Component.Component exposing (AbstractComponent, updateComponents, updateComponentsWithBlock, updateComponentsWithTarget, viewComponents)
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Layer.Layer exposing (ConcreteLayer, Handler, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer, handleComponentMsgs)
import Messenger.Layer.LayerExtra exposing (BasicUpdater, Distributor)
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, InitMsg(..))
import SceneProtos.Game.Play.Attack exposing (judgeAttack)
import SceneProtos.Game.SceneBase exposing (..)
import Time


type alias GameComponent =
    AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg


type alias Data =
    { components : List GameComponent }


init : LayerInit SceneCommonData UserData (LayerMsg SceneMsg) Data
init env initMsg =
    case initMsg of
        PlayInitData data ->
            Data data.components

        _ ->
            Data []



--Dialogue Msg Should be changed before release


handleComponentMsg : Handler Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg ComponentMsg
handleComponentMsg env compmsg data =
    case compmsg of
        SOMMsg som ->
            ( data, [ Parent <| SOMMsg som ], env )

        OtherMsg msg ->
            case msg of
                GameOver ->
                    let
                        cd =
                            env.commonData
                    in
                    ( data, [], { env | commonData = { cd | gameover = True } } )

                _ ->
                    ( data, [], env )


updateBasic : BasicUpdater Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
updateBasic env evt data =
    ( data, [], ( env, False ) )


attackDistributor : Distributor Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg (List ( ComponentTarget, ComponentMsg ))
attackDistributor env evt data =
    ( data, ( [], judgeAttack data.components ), env )


update : LayerUpdate SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
update env evt data =
    if env.globalData.sceneStartFrame == 0 then
        ( data, [ Parent <| SOMMsg <| SOMStopAudio AllAudio ], ( env, False ) )

    else if env.globalData.sceneStartFrame == 1 then
        let
            commonSetting =
                { rate = 1
                , start = Duration.seconds 0
                }

            loopSetting =
                { loopStart = Duration.seconds 0
                , loopEnd = Duration.seconds 16
                }

            newMsg =
                [ Parent <| SOMMsg <| SOMPlayAudio 0 "battle" (ALoop (Just commonSetting) (Just loopSetting)) ]
        in
        ( data, newMsg, ( env, False ) )

    else if not env.commonData.gameover then
        let
            ( data1, lmsg1, ( env1, block1 ) ) =
                updateBasic env evt data

            ( comps1, cmsgs1, ( env2, block2 ) ) =
                updateComponentsWithBlock env1 evt block1 data1.components

            ( data2, ( lmsg2, tocmsg ), env3 ) =
                attackDistributor env2 evt { data1 | components = comps1 }

            ( comps2, cmsgs2, env4 ) =
                updateComponentsWithTarget env3 tocmsg data2.components

            ( data3, lmsgs3, env5 ) =
                handleComponentMsgs env4 (cmsgs2 ++ cmsgs1) { data2 | components = comps2 } (lmsg1 ++ lmsg2) handleComponentMsg
        in
        ( data3, lmsgs3, ( env5, block2 ) )

    else
        ( data, [], ( env, False ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
updaterec env msg data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    let
        background =
            [ renderSprite env.globalData.internalData [] ( 0, 0 ) ( 1920, 1080 ) "battleframe"
            , renderSprite env.globalData.internalData [] ( 20, 20 ) ( 1400, 660 ) "background"
            ]

        outComeView =
            Canvas.group
                []
                (background ++ [ viewComponents env data.components ])
    in
    if env.commonData.gameover then
        Canvas.group []
            [ Canvas.shapes [ fill (Color.rgba 0 0 0 0.7) ] [ rect env.globalData.internalData ( 0, 0 ) ( 1420, 680 ) ]
            , renderTextWithColorCenter env.globalData.internalData 100 "GameOver" "Arial" Color.red ( 720, 340 )
            , outComeView
            ]

    else
        outComeView


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "Play"


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
