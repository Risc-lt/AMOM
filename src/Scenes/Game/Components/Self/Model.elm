module Scenes.Game.Components.Self.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Self


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        SelfInit initData ->
            ( initData, initBaseData )

        _ ->
            ( { x = 800, y = 100, hp = 100, id = 1 }, initBaseData )


handleKeyDown : Int -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleKeyDown key env evnt data basedata =
    case key of
        13 ->
            if basedata.state == GameBegin then
                ( ( data, { basedata | state = PlayerTurn } ), [], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        32 ->
            if basedata.state == PlayerTurn then
                ( ( data, { basedata | state = EnemyMove } ), [ Other ( "Enemy", PhysicalAttack 1 ) ], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            if basedata.state == PlayerTurn then
                ( ( { data | x = 400 }, basedata ), [], ( env, False ) )

            else if basedata.state == EnemyMove then
                ( ( { data | x = 800 }, basedata ), [], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        KeyDown key ->
            if basedata.state == PlayerTurn || basedata.state == GameBegin then
                handleKeyDown key env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        PhysicalAttack id ->
            ( ( { data | hp = data.hp - 10 }, { basedata | state = PlayerTurn, selfHP = basedata.selfHP - 10 } ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( renderSprite env.globalData.internalData [] ( data.x, data.y ) ( 100, 100 ) "magician"
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
