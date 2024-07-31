module SceneProtos.Game.Components.Self.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (empty)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import SceneProtos.Game.Components.Enemy.Init exposing (defaultEnemy)
import SceneProtos.Game.Components.Self.AttackRec2 exposing (handleAttack, handleSkill)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Self.PosExchange exposing (posExchange)
import SceneProtos.Game.Components.Self.RenderChar exposing (renderChar, renderRegion)
import SceneProtos.Game.Components.Self.UpdateOne3 exposing (updateOne)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time exposing (posixToMillis)


type alias Data =
    List Self


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (SelfInit initData) ->
            ( initData, initBaseData )

        _ ->
            ( [], initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    if basedata.isStopped then
        ( ( data, basedata ), [], ( env, False ) )

    else
        let
            posChanged =
                posExchange evnt data basedata

            posMsg =
                if basedata.state == GameBegin then
                    [ Other
                        ( "Enemy"
                        , CharDie <|
                            List.map .position <|
                                List.filter (\s -> s.hp /= 0) <|
                                    posChanged
                        )
                    ]

                else
                    []

            curChar =
                if basedata.state /= GameBegin then
                    if 0 < basedata.curSelf && basedata.curSelf <= 6 then
                        Maybe.withDefault { defaultSelf | position = 0 } <|
                            List.head <|
                                List.filter (\x -> x.position == basedata.curSelf) posChanged

                    else
                        { defaultSelf | position = 0 }

                else
                    defaultSelf

            ( ( newChar, newBasedata ), msg, ( newEnv, flag ) ) =
                if curChar.position /= 0 then
                    updateOne posChanged env evnt curChar basedata

                else
                    ( ( curChar, basedata ), [], ( env, False ) )

            newData =
                if basedata.state /= GameBegin then
                    List.map
                        (\x ->
                            if x.position == basedata.curSelf && x.hp /= 0 then
                                newChar

                            else
                                x
                        )
                        posChanged

                else
                    posChanged

            newData2 =
                List.map
                    (\x ->
                        if x.isAttacked then
                            let
                                remainNum =
                                    posixToMillis env.globalData.currentTimeStamp - basedata.timestamp

                                attackFlag =
                                    if remainNum >= 100 then
                                        not x.isAttacked

                                    else
                                        x.isAttacked
                            in
                            { x | isAttacked = attackFlag }

                        else
                            x
                    )
                    newData

            interfaceMsg =
                [ Other ( "Interface", ChangeStatus (ChangeSelfs newData2) ) ]
        in
        ( ( newData2, newBasedata ), posMsg ++ interfaceMsg ++ msg, ( newEnv, flag ) )


getAttacked : Data -> Int -> Data
getAttacked data position =
    List.map
        (\x ->
            if x.position == position then
                { x | isAttacked = True }

            else
                x
        )
        data


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        Action (EnemyNormal enemy position) ->
            handleAttack enemy position env msg (getAttacked data position) { basedata | timestamp = posixToMillis env.globalData.currentTimeStamp }

        Action StartCounter ->
            ( ( data, { basedata | state = PlayerAttack False } ), [], env )

        Action (EnemySkill enemy skill position) ->
            handleSkill enemy skill position env msg (getAttacked data position) { basedata | timestamp = posixToMillis env.globalData.currentTimeStamp }

        Action (PlayerSkill self skill position) ->
            handleSkill
                { defaultEnemy
                    | attributes = self.attributes
                    , extendValues = self.extendValues
                }
                skill
                position
                env
                msg
                data
                basedata

        AttackSuccess position ->
            let
                newData =
                    List.map
                        (\x ->
                            if x.position == position then
                                if x.energy + 20 > 300 then
                                    { x | energy = 300 }

                                else
                                    { x | energy = x.energy + 20 }

                            else
                                x
                        )
                        data
            in
            ( ( newData, basedata ), [], env )

        ChangeStatus (ChangeState state) ->
            if state == Counter && basedata.state == PlayerReturn True then
                ( ( data, basedata ), [], env )

            else if state == EnemyTurn then
                ( ( data, { basedata | state = state, side = EnemySide } ), [], env )

            else
                ( ( data, { basedata | state = state } ), [], env )

        CharDie length ->
            ( ( data, { basedata | enemyNum = length } ), [], env )

        SwitchTurn pos ->
            if List.any (\s -> s.position == pos && s.hp /= 0) data then
                ( ( data, { basedata | state = PlayerTurn, curSelf = pos, side = PlayerSide } ), [], env )

            else
                ( ( data, basedata )
                , [ Other ( "Interface", ChangeStatus (ChangeSelfs data) )
                  , Other ( "Interface", SwitchTurn 0 )
                  , Other ( "StoryTrigger", SwitchTurn 0 )
                  ]
                , env
                )

        NewRound ->
            ( ( List.map (\d -> { d | state = Waiting }) data, basedata ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver, Other ( "Interface", ChangeStatus (ChangeSelfs data) ) ], env )

        BeginDialogue _ ->
            ( ( data, { basedata | isStopped = True } ), [], env )

        CloseDialogue ->
            ( ( data, { basedata | isStopped = False } ), [], env )

        PutBuff buff num ->
            ( ( List.map
                    (\x ->
                        if x.name == "Cavalry" then
                            { x | buff = x.buff ++ [ ( buff, num ) ] }

                        else
                            x
                    )
                    data
              , basedata
              )
            , []
            , env
            )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        basicView =
            List.map
                (\x -> renderChar x env)
                data

        regionView =
            if basedata.state == GameBegin then
                List.map
                    (\x -> renderRegion x env)
                    data

            else
                [ empty ]
    in
    ( Canvas.group []
        (regionView ++ basicView)
    , 1
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Self"


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
