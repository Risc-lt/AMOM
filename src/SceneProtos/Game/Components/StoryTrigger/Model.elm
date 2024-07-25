module SceneProtos.Game.Components.StoryTrigger.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, InitMsg(..), initBaseData)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (InitData)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..))


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (TriggerInit initData) ->
            ( initData, initBaseData )

        _ ->
            ( [], initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            ( ( data, basedata ), [ Other ( "Interface", CheckIsTriggered data ) ], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        SwitchTurn _ ->
            let
                newData =
                    List.map 
                        (\( t, i ) -> 
                            case t of
                                FrameTrigger num ->
                                    ( FrameTrigger (num - 1), i )

                                _ ->
                                    ( t, i )
                        ) 
                        data
            in
            ( ( newData, basedata ), [], env )

        BeginDialogue id ->
            let
                newData =
                    List.filter
                        (\( _, i ) -> i /= id)
                        data
            in
            ( ( newData, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( Canvas.empty, 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "StoryTrigger"


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
