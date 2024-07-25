module Scenes.Game.Components.StoryTrigger.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, InitMsg(..), initBaseData)
import Scenes.Game.Components.StoryTrigger.Init exposing (InitData)
import Scenes.Game.SceneBase exposing (SceneCommonData)


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
                    List.map (\x -> { x | frameNum = x.frameNum - 1 }) data
            in
            ( ( newData, basedata ), [], env )

        BeginDialogue id ->
            let
                newData =
                    List.filter
                        (\x -> x.id /= id)
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
