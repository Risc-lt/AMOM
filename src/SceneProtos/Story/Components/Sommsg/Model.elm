module SceneProtos.Story.Components.Sommsg.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Duration exposing (Duration)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Audio.Base exposing (AudioOption(..), AudioTarget(..))
import Messenger.Base exposing (GlobalData, UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.Components.Sommsg.Init exposing (InitData, defaultMusic)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        SommsgInit initData ->
            ( initData, initBaseData )

        _ ->
            ( { music = [ defaultMusic ], isPlaying = False }, initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    if data.isPlaying == False then
        case evnt of
            Tick _ ->
                let
                    ( name, length, id ) =
                        Maybe.withDefault defaultMusic <|
                            List.head <|
                                List.sortBy (\( _, _, i ) -> i) <|
                                    data.music

                    newMusic =
                        List.filter (\( _, _, i ) -> i /= id) data.music

                    commonSetting =
                        { rate = 1
                        , start = Duration.seconds 0
                        }

                    loopSetting =
                        { loopStart = Duration.seconds 0
                        , loopEnd = Duration.seconds length
                        }

                    newMsg =
                        [ Parent <| SOMMsg <| SOMPlayAudio 0 name (ALoop (Just commonSetting) (Just loopSetting)) ]
                in
                ( ( { data | music = newMusic, isPlaying = True }, basedata ), newMsg, ( env, False ) )

            _ ->
                ( ( data, basedata ), [], ( env, False ) )

    else
        ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        BeginPlot id ->
            let
                newMusic =
                    List.any (\( _, _, i ) -> i == id) data.music

                newMsg =
                    if newMusic then
                        [ Parent <| SOMMsg <| SOMStopAudio AllAudio ]

                    else
                        []
            in
            if newMusic then
                ( ( { data | isPlaying = False }, basedata ), newMsg, env )

            else
                ( ( data, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( Canvas.empty, 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Sommsg"


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Component generator
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
