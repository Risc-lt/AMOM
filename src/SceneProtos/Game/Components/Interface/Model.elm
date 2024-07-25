module Scenes.Game.Components.Interface.Model exposing (component)

{-| Component model

@docs component

-}

import Array exposing (get)
import Canvas
import Debug exposing (toString)
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
import Scenes.Game.Components.StoryTrigger.Init exposing (TriggerConditions)
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


updateBaseData : BaseData -> Data -> ( Data, BaseData, List (Msg String ComponentMsg (SceneOutputMsg SceneMsg UserData)) )
updateBaseData basedata data =
    let
        ( nextOne, nextIndex, isNewRound ) =
            nextChar data basedata

        newside =
            checkSide nextOne

        newMsg =
            if isNewRound then
                [ Other ( "Enemy", NewRound )
                , Other ( "Self", NewRound )
                ]

            else
                []
    in
    ( { data | curIndex = nextIndex }, { basedata | side = newside, curSelf = nextOne }, newMsg )


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


checkOneTrigger : TriggerConditions -> Data -> BaseData -> Int
checkOneTrigger trigger data basedata =
    case trigger.side of
        "Enemy" ->
            if
                (trigger.frameNum
                    <= 0
                    && List.any (\x -> x.hp == trigger.hpTrigger) data.enemies
                    && trigger.gameState
                    == toString basedata.state
                )
                    || (trigger.id == 101 && List.length data.enemies < 6)
            then
                trigger.id

            else
                -1

        "Self" ->
            if
                trigger.frameNum
                    <= 0
                    && List.any (\x -> x.hp == trigger.hpTrigger) data.enemies
                    && trigger.gameState
                    == toString basedata.state
            then
                trigger.id

            else
                -1

        _ ->
            -1


handleCheckTrigger : Data -> BaseData -> List TriggerConditions -> List (Msg String ComponentMsg (SceneOutputMsg SceneMsg UserData))
handleCheckTrigger data basedata triggers =
    let
        maybeTrigger =
            List.filter (\x -> x /= -1) <|
                List.map (\trigger -> checkOneTrigger trigger data basedata) triggers

        msg =
            List.map (\x -> Other ( "Dialogue", BeginDialogue x )) maybeTrigger

        deleteTriggerMsg =
            List.map (\x -> Other ( "StoryTrigger", BeginDialogue x )) maybeTrigger
    in
    msg ++ deleteTriggerMsg


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
                ( newData, newBaseData, newRoundMsg ) =
                    updateBaseData basedata data

                ( newState, newMsg ) =
                    sendMsg newData newBaseData
            in
            ( ( newData, { newBaseData | state = newState } ), newRoundMsg ++ newMsg, env )

        CheckIsTriggered triggerList ->
            let
                newMsg =
                    handleCheckTrigger data basedata triggerList
            in
            ( ( data, basedata ), newMsg, env )

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
