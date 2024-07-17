module Scenes.Game.Components.Interface.Model exposing (component)

{-| Component model

@docs component

-}

import Array exposing (get)
import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Scene.Scene exposing (SceneOutputMsg)
import Scenes.Game.Components.ComponentBase exposing (ActionSide(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import Scenes.Game.Components.Interface.Init exposing (InitData, defaultUI)
import Scenes.Game.Components.Interface.RenderHelper exposing (renderAction, renderStatus)
import Scenes.Game.Components.Interface.Sequence exposing (checkSide, getFirstChar, getQueue, initUI, nextChar, nextSelf, renderQueue)
import Scenes.Game.Components.Self.Init exposing (State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        UIInit initData ->
            let
                ( firstdata, firstBaseData ) =
                    initUI env initData initBaseData
            in
            ( firstdata, firstBaseData )

        _ ->
            ( defaultUI, initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            let
                newQueue =
                    getQueue data.selfs data.enemies env
            in
            ( ( data, { basedata | queue = newQueue } ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updateBaseData : List Int -> BaseData -> BaseData
updateBaseData queue basedata =
    let
        nextOne =
            nextChar (Debug.log "queue" queue) (Debug.log "cur" basedata.curChar)

        newside =
            checkSide nextOne
    in
    { basedata | side = newside, curChar = nextOne }


sendMsg : BaseData -> ( Gamestate, List (Msg String ComponentMsg (SceneOutputMsg SceneMsg UserData)) )
sendMsg basedata =
    case basedata.side of
        PlayerSide ->
            ( PlayerTurn, [ Other ( "Self", SwitchTurn basedata.curChar ) ] )

        EnemySide ->
            ( EnemyMove, [ Other ( "Enemy", SwitchTurn basedata.curChar ) ] )

        _ ->
            ( basedata.state, [] )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        ChangeSelfs list ->
            ( ( { data | selfs = list }, basedata ), [], env )

        ChangeEnemies list ->
            ( ( { data | enemies = list }, basedata ), [], env )

        ChangeBase newBaseData ->
            ( ( data, newBaseData ), [], env )

        SwitchTurn _ ->
            let
                newQueue =
                    getQueue data.selfs data.enemies env

                newBaseData =
                    updateBaseData newQueue basedata

                ( newState, newMsg ) =
                    sendMsg newBaseData
            in
            ( ( data, { basedata | state = newState } ), newMsg, env )

        StartGame ->
            let
                ( firstState, newMsg ) =
                    sendMsg basedata
            in
            ( ( data, { basedata | state = firstState } ), newMsg, env )

        UpdateChangingPos selfs ->
            let
                newQueue =
                    getQueue selfs data.enemies env
            in
            ( ( { data | selfs = selfs }, { basedata | queue = newQueue } ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        statusView =
            List.map
                (\x ->
                    renderStatus x env
                )
                data.selfs

        actionView =
            renderAction env data basedata

        actionBar =
            renderQueue env data.selfs data.enemies
    in
    ( Canvas.group []
        [ actionView
        , Canvas.group [] statusView
        , Canvas.group [] actionBar
        ]
    , 2
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Interface"


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
