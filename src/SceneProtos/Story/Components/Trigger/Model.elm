module SceneProtos.Story.Components.Trigger.Model exposing (..)

{-| Component model

@docs component

-}

import Bitwise exposing (or)
import Canvas
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (GlobalData, UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (InitData, defaultDialogue)
import SceneProtos.Story.Components.Trigger.Init exposing (InitData)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        TriggerInit over ->
            ( { id = 0, curPlot = [], overId = over }, initBaseData )

        _ ->
            ( { id = 0, curPlot = [], overId = 0 }, initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            if data.id == data.overId then
                ( ( data, basedata ), [ Parent <| OtherMsg <| Over ], ( env, False ) )

            else if basedata.isPlaying == False then
                ( ( { data | id = data.id + 1 }, basedata )
                , [ Other ( "Background", BeginPlot (data.id + 1) )
                  , Other ( "Character", BeginPlot (data.id + 1) )
                  , Other ( "Dialogue", BeginPlot (data.id + 1) )
                  , Other ( "Sommsg", BeginPlot (data.id + 1) )
                  ]
                , ( env, False )
                )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        BeginPlot id ->
            ( ( { data | curPlot = id :: data.curPlot }, { basedata | isPlaying = True } ), [], env )

        PlotDone id ->
            let
                newPlot =
                    List.filter (\i -> i /= id) data.curPlot

                newBasedata =
                    if List.length newPlot == 0 then
                        { basedata | isPlaying = False }

                    else
                        basedata
            in
            ( ( { data | curPlot = newPlot }, newBasedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( Canvas.empty, 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Trigger"


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
