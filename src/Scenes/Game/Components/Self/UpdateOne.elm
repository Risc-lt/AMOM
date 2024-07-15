module Scenes.Game.Components.Self.UpdateOne exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..))
import Scenes.Game.Components.Self.Reaction exposing (findMin)
import Scenes.Game.Components.Self.Sequence exposing (getFirstChar, nextChar)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Self


handleKeyDown : Int -> List Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleKeyDown key list env evnt data basedata =
    case key of
        13 ->
            if basedata.state == GameBegin then
                ( ( data, { basedata | state = PlayerTurn } ), [ Other ( "Interface", SwitchTurn ) ], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


handleMouseDown : Float -> Float -> Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMouseDown x y self env evnt data basedata =
    case basedata.state of
        PlayerTurn ->
            if x > 320 && x < 540 && y > 680 && y < 1080 then
                ( ( data, { basedata | state = TargetSelection } ), [], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        TargetSelection ->
            let
                position =
                    if x > 640 && x < 1030 && y > 680 && y < 813.3 then
                        10

                    else if x > 640 && x < 1030 && y > 813.3 && y < 946.6 then
                        11

                    else if x > 640 && x < 1030 && y > 946.6 && y < 1080 then
                        12

                    else if x > 1030 && x < 1420 && y > 680 && y < 813.3 then
                        7

                    else if x > 1030 && x < 1420 && y > 813.3 && y < 946.6 then
                        8

                    else if x > 1030 && x < 1420 && y > 946.6 && y < 1080 then
                        9

                    else
                        0

                melee =
                    self.career == "swordsman" || self.career == "pharmacist"

                front =
                    List.any (\p -> p <= 9) basedata.enemyNum

                effective =
                    if melee && front && position > 9 then
                        False

                    else
                        True

                newState =
                    if List.member position basedata.enemyNum && effective then
                        PlayerAttack

                    else
                        TargetSelection
            in
            ( ( data, { basedata | curEnemy = position, state = newState } ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


handleMove : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove list env evnt data basedata =
    let
        returnX =
            if data.position <= 3 then
                1100

            else
                1220

        newX =
            if basedata.state == PlayerAttack then
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

        newBaseData =
            if basedata.state == PlayerReturn && newX >= returnX then
                { basedata | state = PlayerTurn, curChar = nextChar basedata.queue basedata.curChar }

            else if basedata.state == PlayerAttack && newX <= 670 then
                { basedata | state = PlayerReturn }

            else
                basedata

        msg =
            if basedata.state == PlayerAttack && newX <= 670 then
                [ Other ( "Enemy", AttackEnemy NormalAttack data basedata.curEnemy ) ]

            else
                []
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

        MouseUp key ( x, y ) ->
            if key == 0 then
                handleMouseDown x y data env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
