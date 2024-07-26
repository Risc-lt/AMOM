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
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (InitData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (defaultDialogue)

type alias Data =
    Int

init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        TriggerInit ->
            ( 0, initBaseData )

        _ ->
            ( 0, initBaseData)


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            if basedata.isPlaying == False then
                ( ( data + 1, basedata )
                , [ Other ( "Background", BeginPlot (data + 1) ) 
                  , Other ( "Character", BeginPlot (data + 1) )
                  , Other ( "Dialogue", BeginPlot (data + 1) ) 
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
        BeginPlot _ ->
            ( ( data, { basedata | isPlaying = True } ), [], env )

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
