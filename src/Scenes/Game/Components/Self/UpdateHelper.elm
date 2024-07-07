module Scenes.Game.Components.Self.UpdateHelper exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..))
import Scenes.Game.Components.Self.Reaction exposing (findMin)
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
                let
                    attackMsg =
                        if data.career == "archer" then
                            [ Other ( "Enemy", Attack Physical basedata.curEnemy ) ]

                        else
                            [ Other ( "Enemy", Attack Magical basedata.curEnemy ) ]
                in
                ( ( data, { basedata | state = PlayerReturn } ), attackMsg, ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


handleMove : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove list env evnt data basedata =
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
                if basedata.curChar == 2 then
                    ( { basedata | state = EnemyMove, curChar = findMin list }, [ Other ( "Enemy", SwitchTurn ) ] )

                else
                    ( { basedata | state = PlayerTurn, curChar = basedata.curChar + 1 }, [] )

            else
                ( basedata, [] )
    in
    ( ( { data | x = newX }, newBaseData ), msg, ( env, False ) )


updateOne : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne list env evnt data basedata =
    case evnt of
        Tick _ ->
            handleMove list env evnt data basedata

        KeyDown key ->
            if (basedata.state == PlayerTurn && data.x <= 400) || basedata.state == GameBegin then
                handleKeyDown key env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
