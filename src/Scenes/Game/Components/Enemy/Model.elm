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
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Enemy


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        EnemyInit initData ->
            ( initData, initBaseData )

        _ ->
            ( { x = 100, y = 100, hp = 100, id = 1 }, initBaseData )


attackPlayer : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
attackPlayer env evnt data basedata =
    ( ( data, { basedata | state = PlayerTurn } ), [ Other ( "Self", PhysicalAttack 1 ) ], ( env, False ) )


handleMove : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove env evnt data basedata =
    let
        newX =
            if basedata.state == EnemyMove then
                if data.x < 400 then
                    data.x + 2

                else
                    data.x

            else if basedata.state == PlayerTurn then
                if data.x > 100 then
                    data.x - 2

                else
                    data.x

            else
                data.x

        newBaseData =
            if basedata.state == EnemyMove then
                if newX >= 400 then
                    { basedata | state = EnemyAttack }

                else
                    basedata

            else
                basedata
    in
    ( ( { data | x = newX }, newBaseData ), [], ( env, False ) )


handlePlayerTurn : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handlePlayerTurn env evnt data basedata =
    if basedata.state == EnemyAttack then
        attackPlayer env evnt data basedata

    else
        handleMove env evnt data basedata


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            handlePlayerTurn env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        PhysicalAttack id ->
            ( ( { data | hp = data.hp - 10 }, { basedata | state = EnemyMove, enemyHP = basedata.enemyHP - 10 } ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        hpBar =
            Canvas.shapes
                [ fill Color.red ]
                [ rect env.globalData.internalData ( data.x, data.y ) ( 100 * (data.hp / 100), 5 ) ]
    in
    ( Canvas.group []
        [ renderSprite env.globalData.internalData [] ( data.x, data.y ) ( 100, 100 ) "uglyman"
        , hpBar
        ]
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
