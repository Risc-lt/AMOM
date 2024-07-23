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
import Scenes.Game.Components.ComponentBase exposing (ActionSide(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import Scenes.Game.Components.Interface.Init exposing (InitData, defaultUI)
import Scenes.Game.Components.Interface.RenderHelper exposing (renderAction, renderStatus)
import Scenes.Game.Components.Interface.Sequence exposing (checkSide, getFirstChar, getQueue, initUI, nextChar, renderQueue)
import Scenes.Game.Components.Self.Init exposing (State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (UIInit initData) ->
            let
                ( firstdata, firstBaseData ) =
                    initUI initData initBaseData
            in
            ( firstdata, firstBaseData )

        _ ->
            ( defaultUI, initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updateBaseData : BaseData -> Data -> ( Data, BaseData )
updateBaseData basedata data =
    let
        ( nextOne, nextIndex ) =
            nextChar data basedata

        newside =
            checkSide nextOne
    in
    ( { data | curIndex = nextIndex }, { basedata | side = newside, curSelf = nextOne } )


sendMsg : Data -> BaseData -> ( Gamestate, List (Msg String ComponentMsg (SceneOutputMsg SceneMsg UserData)) )
sendMsg data basedata =
    case basedata.side of
        PlayerSide ->
            ( PlayerTurn
            , [ Other ( "Self", SwitchTurn basedata.curSelf )
              , Other ( "Enemy", ChangeStatus (ChangeState PlayerTurn) )
              ]
            )

        EnemySide ->
            ( EnemyTurn
            , [ Other ( "Enemy", SwitchTurn basedata.curSelf )
              , Other ( "Self", ChangeStatus (ChangeState EnemyTurn) )
              ]
            )

        _ ->
            ( basedata.state, [] )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        ChangeStatus (ChangeSelfs list) ->
            let
                newQueue =
                    getQueue list data.enemies
            in
            ( ( { data | selfs = list, queue = newQueue }, basedata ), [], env )

        ChangeStatus (ChangeEnemies list) ->
            let
                newQueue =
                    getQueue data.selfs list
            in
            ( ( { data | enemies = list, queue = newQueue }, basedata ), [], env )

        ChangeStatus (ChangeState state) ->
            ( ( data, { basedata | state = state } ), [], env )

        SwitchTurn _ ->
            let
                ( newData, newBaseData ) =
                    updateBaseData basedata data

                ( newState, newMsg ) =
                    sendMsg newData newBaseData
            in
            ( ( newData, { newBaseData | state = newState } ), newMsg, env )

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
            renderQueue env data
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
