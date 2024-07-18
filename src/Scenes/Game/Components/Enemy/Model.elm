module Scenes.Game.Components.Enemy.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Canvas.Settings exposing (fill)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import Scenes.Game.Components.Enemy.AttackRec exposing (findMin, handleAttack)
import Scenes.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.Enemy.UpdateOne exposing (updateOne)
import Scenes.Game.Components.Self.Init exposing (State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)


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
    let
        curEnemy =
            if 7 <= basedata.curChar && basedata.curChar <= 12 then
                Maybe.withDefault { defaultEnemy | position = 0 } <|
                    List.head <|
                        List.filter (\x -> x.position == basedata.curChar) data

            else
                { defaultEnemy | position = 0 }

        ( ( newEnemy, newBasedata ), msg, ( newEnv, flag ) ) =
            if curEnemy.position /= 0 then
                updateOne data env evnt curEnemy basedata

            else
                ( ( curEnemy, basedata ), [], ( env, False ) )

        newData =
            List.map
                (\x ->
                    if x.position == basedata.curChar then
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
        Action (PlayerNormal self position isCounter) ->
            handleAttack isCounter self position env msg data basedata

        AttackSuccess position ->
            let
                newData =
                    List.map
                        (\x ->
                            if x.position == position then
                                { x | energy = x.energy + 20 }

                            else
                                x
                        )
                        data
            in
            ( ( newData, basedata ), [], env )

        CharDie length ->
            ( ( data, { basedata | selfNum = length } ), [], env )

        SwitchTurn pos ->
            ( ( data, { basedata | state = EnemyMove, curChar = pos } ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        _ ->
            ( ( data, basedata ), [], env )


renderEnemy : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderEnemy enemy env =
    Canvas.group []
        [ renderSprite env.globalData.internalData [] ( enemy.x, enemy.y ) ( 100, 100 ) enemy.name
        , Canvas.shapes
            [ fill Color.red ]
            [ rect env.globalData.internalData
                ( enemy.x, enemy.y )
                ( toFloat (100 * (enemy.hp // enemy.extendValues.basicStatus.maxHp)), 5 )
            ]
        ]


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
