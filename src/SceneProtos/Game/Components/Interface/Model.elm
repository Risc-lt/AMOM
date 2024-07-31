module SceneProtos.Game.Components.Interface.Model exposing (component)

{-| Component model

@docs component

-}

import Array exposing (get)
import Canvas
import Current exposing (Current)
import Debug exposing (toString)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionSide(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import SceneProtos.Game.Components.Interface.Init exposing (InitData, defaultUI)
import SceneProtos.Game.Components.Interface.RenderHelper exposing (renderStatus)
import SceneProtos.Game.Components.Interface.RenderHelper2 exposing (renderAction)
import SceneProtos.Game.Components.Interface.Sequence exposing (checkSide, getQueue, initUI, nextChar, renderQueue)
import SceneProtos.Game.Components.Self.Init exposing (State(..))
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (UIInit initData) ->
            let
                ( firstdata, firstBaseData ) =
                    initUI initData initBaseData

                newNum =
                    List.filter
                        (\n ->
                            List.member n <|
                                List.map (\s -> s.position) <|
                                    List.filter (\s -> s.hp /= 0) firstdata.enemies
                        )
                        firstBaseData.enemyNum
            in
            ( firstdata, { firstBaseData | enemyNum = newNum } )

        _ ->
            ( defaultUI, initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        KeyDown key ->
            if key == 27 then
                ( ( data, basedata ), [ Parent (SOMMsg (SOMChangeScene Nothing "Home")) ], ( env, False ) )

            else
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


checkOneTrigger : ( TriggerConditions, Int ) -> Data -> BaseData -> ( Int, Bool )
checkOneTrigger ( trigger, id ) data basedata =
    case trigger of
        FrameTrigger num ->
            if num <= 0 then
                ( id, False )

            else
                ( -1, False )

        StateTrigger state ->
            if toString basedata.state == state then
                ( id, False )

            else
                ( -1, False )

        DieTrigger ->
            if List.any (\s -> s.hp /= 0 && s.name == "Cavalry") data.selfs then
                if List.length data.enemies /= 6 then
                    ( id, False )

                else
                    ( -1, False )

            else
                ( id, True )


handleCheckTrigger : Data -> BaseData -> List ( TriggerConditions, Int ) -> List (Msg String ComponentMsg (SceneOutputMsg SceneMsg UserData))
handleCheckTrigger data basedata triggers =
    let
        ( maybeTrigger, isOver ) =
            List.unzip <|
                List.filter (\( x, _ ) -> x /= -1) <|
                    List.map (\trigger -> checkOneTrigger trigger data basedata) triggers

        successMsg =
            List.map (\x -> Other ( "Dialogue", BeginDialogue x )) maybeTrigger

        deleteTriggerMsg =
            List.map (\x -> Other ( "StoryTrigger", BeginDialogue x )) maybeTrigger

        gameOverMsg =
            if List.member True isOver then
                [ Other ( "Self", Defeated ) ]

            else
                []
    in
    successMsg ++ deleteTriggerMsg ++ gameOverMsg


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        ChangeStatus (ChangeSelfs list) ->
            let
                newQueue =
                    getQueue list data.enemies

                numDifference =
                    if List.length newQueue < List.length data.queue then
                        List.length newQueue - List.length data.queue - 1

                    else
                        0
            in
            ( ( { data | selfs = list, queue = newQueue, curIndex = data.curIndex - numDifference }, basedata )
            , []
            , env
            )

        ChangeStatus (ChangeEnemies list) ->
            let
                newQueue =
                    getQueue data.selfs list

                numDifference =
                    if List.length newQueue < List.length data.queue then
                        List.length newQueue - List.length data.queue - 1

                    else
                        0
            in
            ( ( { data | enemies = list, queue = newQueue, curIndex = data.curIndex - numDifference }, basedata )
            , []
            , env
            )

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
