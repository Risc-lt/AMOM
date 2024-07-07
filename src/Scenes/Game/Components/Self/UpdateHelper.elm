module Scenes.Game.Components.Self.UpdateHelper exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Self


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
                ( ( data, { basedata | state = PlayerReturn } ), [ Other ( "Enemy", PhysicalAttack 1 ) ], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


handleMove : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove env evnt data basedata =
    let
        newX =
            if basedata.state == PlayerTurn then
                if data.x > 400 then
                    data.x - 2

                else
                    data.x

            else if basedata.state == PlayerReturn then
                if data.x < 800 then
                    data.x + 2

                else
                    data.x

            else
                data.x

        ( newBaseData, msg ) =
            if basedata.state == PlayerReturn && newX >= 800 then
                ( { basedata | state = EnemyMove }, [ Other ( "Enemy", SwitchTurn ) ] )

            else
                ( basedata, [] )
    in
    ( ( { data | x = newX }, newBaseData ), msg, ( env, False ) )


updateOne : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne env evnt data basedata =
    case evnt of
        Tick _ ->
            handleMove env evnt data basedata

        KeyDown key ->
            if (basedata.state == PlayerTurn && data.x <= 400) || basedata.state == GameBegin then
                handleKeyDown key env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
