module SceneProtos.Game.Components.Enemy.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import SceneProtos.Game.Components.Enemy.AttackRec exposing (findMin, handleAttack, handleSkill)
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, State(..), defaultEnemy, emptyInitData, genDefaultEnemy)
import SceneProtos.Game.Components.Enemy.UpdateOne exposing (getTarget, updateOne)
import SceneProtos.Game.Components.Self.Init exposing (defaultSelf)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Enemy


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (EnemyInit initData) ->
            ( initData, initBaseData )

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
                        if x.position == basedata.curEnemy then
                            newEnemy

                        else
                            x
                    )
                    data
        in
        ( ( newData, newBasedata ), Other ( "Interface", ChangeStatus (ChangeEnemies newData) ) :: msg, ( newEnv, flag ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        Action (PlayerNormal self position) ->
            handleAttack self position env msg data basedata

        Action StartCounter ->
            ( ( data, { basedata | state = EnemyAttack } ), [], env )

        Action (PlayerSkill self skill position) ->
            let
                newData =
                    List.map
                        (\x ->
                            if x.position == position then
                                { x | curHurt = skill.name }

                            else
                                x
                        )
                        data
            in
            handleSkill self skill position env msg newData basedata

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
            if state == PlayerTurn then
                ( ( data, { basedata | state = state, side = PlayerSide } ), [], env )

            else
                ( ( data, { basedata | state = state } ), [], env )

        CharDie length ->
            ( ( data, { basedata | selfNum = length } ), [], env )

        SwitchTurn pos ->
            if List.any (\e -> e.position == pos && e.hp /= 0) data then
                ( ( data, { basedata | state = EnemyTurn, curEnemy = pos, side = EnemySide } )
                , []
                , env
                )

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

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        BeginDialogue _ ->
            ( ( data, { basedata | isStopped = True } ), [], env )

        CloseDialogue ->
            ( ( data, { basedata | isStopped = False } ), [], env )

        AddChar ->
            let
                emptySlot =
                    Maybe.withDefault -1 <|
                        List.head <|
                            List.filter (\x -> List.filter (\y -> y.position == x) data == []) [ 7, 8, 9, 10, 11, 12 ]

                newEnemy =
                    genDefaultEnemy emptySlot

                newData =
                    newEnemy :: data
            in
            ( ( newData, { basedata | curEnemy = basedata.curEnemy + 1 } ), [], env )

        PutBuff buff num ->
            -- Add buff to all enemies
            ( ( List.map (\x -> { x | buff = x.buff ++ [ ( buff, num ) ] }) data, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


renderEnemy : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderEnemy enemy env =
    let
        gd =
            env.globalData

        rate =
            300

        currentAct x =
            String.fromInt (modBy (rate * x) gd.sceneStartTime // rate)

        skillView =
            if enemy.curHurt /= "" then
                [ renderSprite env.globalData.internalData [ imageSmoothing False ] ( enemy.x, enemy.y ) ( 100, 100 ) (enemy.curHurt ++ "./" ++ currentAct 17) ]

            else
                [ Canvas.empty ]
    in
    if enemy.hp == 0 then
        Canvas.empty

    else
        Canvas.group []
            ([ renderSprite env.globalData.internalData [] ( enemy.x, enemy.y ) ( 100, 100 ) enemy.name
             , Canvas.shapes
                [ fill Color.red ]
                [ rect env.globalData.internalData
                    ( enemy.x, enemy.y )
                    ( 100 * toFloat enemy.hp / toFloat enemy.extendValues.basicStatus.maxHp, 5 )
                ]
             ]
                ++ skillView
            )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        basicView =
            List.map
                (\x -> renderEnemy x env)
                data
    in
    ( Canvas.group []
        basicView
    , 1
    )


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
