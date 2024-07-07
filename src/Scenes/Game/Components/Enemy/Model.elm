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
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import Scenes.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.Enemy.UpdateOne exposing (updateOne)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Enemy


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        EnemyInit initData ->
            ( initData, initBaseData )

        _ ->
            ( [], initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        curEnemy =
            Maybe.withDefault { defaultEnemy | id = 0 } <|
                List.head <|
                    List.filter (\x -> x.id == basedata.curEnemy) data

        ( ( newEnemy, newBasedata ), msg, ( newEnv, flag ) ) =
            updateOne env evnt curEnemy basedata

        newData =
            List.map
                (\x ->
                    if x.id == basedata.curEnemy then
                        newEnemy

                    else
                        x
                )
                data
    in
    ( ( newData, newBasedata ), msg, ( newEnv, flag ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        Attack _ id ->
            let
                curEnemy =
                    Maybe.withDefault { defaultEnemy | id = 0 } <|
                        List.head <|
                            List.filter (\x -> x.id == id) data

                newData =
                    List.map
                        (\x ->
                            if x.id == id then
                                { x | hp = x.hp - 10 }

                            else
                                x
                        )
                        data
            in
            ( ( newData, { basedata | enemyHP = curEnemy.hp } ), [], env )

        SwitchTurn ->
            ( ( data, { basedata | state = EnemyMove } ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        _ ->
            ( ( data, basedata ), [], env )


renderEnemy : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderEnemy enemy env =
    Canvas.group []
        [ renderSprite env.globalData.internalData [] ( enemy.x, enemy.y ) ( 100, 100 ) "uglyman"
        , Canvas.shapes
            [ fill Color.red ]
            [ rect env.globalData.internalData ( enemy.x, enemy.y ) ( 100 * (enemy.hp / 100), 5 ) ]
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
