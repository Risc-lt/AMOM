module Scenes.Game.Components.Self.UpdateOne exposing (..)

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


handleKeyDown : Int -> List Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleKeyDown key list env evnt data basedata =
    case key of
        13 ->
            if basedata.state == GameBegin then
                ( ( data, { basedata | state = PlayerTurn, curChar = findMin list } ), [], ( env, False ) )

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


handleMouseDown : Float -> Float -> Data -> Data
handleMouseDown x y data =
    if x > data.x - 5 && x < data.x + 105 && y > data.y - 5 && y < data.y + 105 then
        if data.state /= Working then
            { data | state = Working }

        else if data.state == Working then
            { data | state = Waiting }

        else
            data

    else
        data


handleMove : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove list env evnt data basedata =
    let
        returnX =
            if data.position <= 3 then
                1100

            else
                1220

        newX =
            if basedata.state == PlayerTurn then
                if data.x > 670 then
                    data.x - 5

                else
                    670

            else if basedata.state == PlayerReturn then
                if data.x < returnX then
                    data.x + 5

                else
                    returnX

            else
                data.x

        ( newBaseData, msg ) =
            if basedata.state == PlayerReturn && newX >= returnX then
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
            if (basedata.state == PlayerTurn && data.x <= 670) || basedata.state == GameBegin then
                handleKeyDown key list env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
