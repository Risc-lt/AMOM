module SceneProtos.Game.Components.Enemy.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (imageSmoothing, rotate, transform)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import SceneProtos.Game.Components.Enemy.AttackRec2 exposing (handleAttack, handleSkill)
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, State(..), defaultEnemy, genDefaultEnemy)
import SceneProtos.Game.Components.Enemy.UpdateOne2 exposing (updateOne)
import SceneProtos.Game.Components.Self.Init exposing (defaultSelf)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time exposing (posixToMillis)


type alias Data =
    List Enemy


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (EnemyInit initData) ->
            let
                newNum =
                    List.filter
                        (\n ->
                            List.member n <|
                                List.map (\s -> s.position) <|
                                    List.filter (\s -> s.hp /= 0) initData
                        )
                        initBaseData.enemyNum
            in
            ( initData, { initBaseData | enemyNum = newNum } )

        _ ->
            ( [], initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    if basedata.isStopped then
        ( ( data, basedata ), [], ( env, False ) )

    else
        let
            curEnemy =
                if 7 <= basedata.curEnemy && basedata.curEnemy <= 12 then
                    Maybe.withDefault { defaultEnemy | position = 0 } <|
                        List.head <|
                            List.filter (\x -> x.position == basedata.curEnemy) data

                else
                    { defaultEnemy | position = 0 }

            ( ( newEnemy, newBasedata ), msg, ( newEnv, flag ) ) =
                if curEnemy.position /= 0 then
                    updateOne env evnt curEnemy basedata

                else
                    ( ( curEnemy, basedata ), [], ( env, False ) )

            newData =
                List.map
                    (\x ->
                        let
                            updatedEnemy =
                                if x.position == basedata.curEnemy then
                                    newEnemy

                                else
                                    x

                            updatedHurt =
                                if updatedEnemy.curHurt /= "" then
                                    let
                                        remainNum =
                                            posixToMillis env.globalData.currentTimeStamp - basedata.timestamp

                                        newName =
                                            if remainNum >= 100 then
                                                ""

                                            else
                                                updatedEnemy.curHurt
                                    in
                                    { updatedEnemy | curHurt = newName }

                                else
                                    updatedEnemy
                        in
                        updatedHurt
                    )
                    data
        in
        ( ( newData, newBasedata ), Other ( "Interface", ChangeStatus (ChangeEnemies newData) ) :: msg, ( newEnv, flag ) )


addCurHurt : Data -> Int -> Data
addCurHurt data position =
    List.map
        (\x ->
            if x.position == position then
                { x | curHurt = "Hurted" }

            else
                x
        )
        data


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        Action (PlayerNormal self position) ->
            handleAttack self position env msg (addCurHurt data position) { basedata | timestamp = posixToMillis env.globalData.currentTimeStamp }

        Action StartCounter ->
            ( ( data, { basedata | state = EnemyAttack } ), [], env )

        Action (PlayerSkill self skill position) ->
            handleSkill self skill position env msg (addCurHurt data position) { basedata | timestamp = posixToMillis env.globalData.currentTimeStamp }

        Action (EnemySkill enemy skill position) ->
            handleSkill
                { defaultSelf
                    | attributes = enemy.attributes
                    , extendValues = enemy.extendValues
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
            let
                newNum =
                    if basedata.state == GameBegin then
                        [ Other ( "Self", CharDie basedata.enemyNum ) ]

                    else
                        []
            in
            if state == PlayerTurn then
                ( ( data, { basedata | state = state, side = PlayerSide } ), newNum, env )

            else
                ( ( data, { basedata | state = state } ), [], env )

        CharDie length ->
            ( ( data, { basedata | selfNum = length } ), [], env )

        SwitchTurn pos ->
            if List.any (\e -> e.position == pos && e.hp /= 0) data then
                ( ( data, { basedata | state = EnemyTurn, curEnemy = pos, side = EnemySide } ), [], env )

            else
                ( ( data, basedata )
                , [ Other ( "Interface", ChangeStatus (ChangeEnemies data) )
                  , Other ( "Interface", SwitchTurn 1 )
                  , Other ( "StoryTrigger", SwitchTurn 1 )
                  ]
                , env
                )

        NewRound ->
            ( ( List.map (\d -> { d | state = Waiting }) data, basedata ), [], env )

        Defeated _ ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        BeginDialogue _ ->
            ( ( data, { basedata | isStopped = True } ), [], env )

        CloseDialogue ->
            ( ( data, { basedata | isStopped = False } ), [], env )

        AddChar ->
            let
                emptySlot =
                    List.filter (\x -> List.filter (\y -> y.position == x) data == []) [ 7, 8, 9, 10, 11, 12 ]

                newEnemy =
                    List.map
                        (genDefaultEnemy <| Time.posixToMillis env.globalData.currentTimeStamp)
                        emptySlot

                newNum =
                    List.map (\e -> e.position) (newEnemy ++ data)
            in
            ( ( newEnemy ++ data, { basedata | curEnemy = basedata.curEnemy + 1, enemyNum = newNum } )
            , [ Other ( "Self", CharDie newNum ) ]
            , env
            )

        _ ->
            ( ( data, basedata ), [], env )


renderEnemy : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderEnemy enemy env =
    let
        currentAct x =
            String.fromInt (modBy (300 * x) env.globalData.sceneStartTime // 300)

        enemyView =
            if enemy.curHurt /= "" then
                Canvas.group []
                    [ renderSprite env.globalData.internalData [ [ rotate (-30 * pi / 180) ] |> transform ] ( enemy.x - 30, enemy.y + 20 ) ( 100, 100 ) (enemy.name ++ "Sheet.1/1") ]

            else if enemy.isRunning then
                renderSprite env.globalData.internalData [ imageSmoothing False ] ( enemy.x, enemy.y ) ( 100, 100 ) (enemy.name ++ "Sheet.1/" ++ currentAct 3)

            else
                renderSprite env.globalData.internalData [ imageSmoothing False ] ( enemy.x, enemy.y ) ( 100, 100 ) (enemy.name ++ "Sheet.0/" ++ currentAct 2)
    in
    if enemy.hp == 0 then
        Canvas.empty

    else
        Canvas.group []
            [ Canvas.shapes
                [ fill Color.red ]
                [ rect env.globalData.internalData
                    ( enemy.x, enemy.y )
                    ( 100 * toFloat enemy.hp / toFloat enemy.extendValues.basicStatus.maxHp, 5 )
                ]
            , enemyView
            ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        basicView =
            List.map
                (\x -> renderEnemy x env)
                data
    in
    ( Canvas.group [] basicView, 1 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Enemy"


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
