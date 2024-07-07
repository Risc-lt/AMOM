module Scenes.Game.Components.Enemy.UpdateOne exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Enemy


attackPlayer : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
attackPlayer env evnt data basedata =
    ( ( data, { basedata | state = EnemyReturn } ), [ Other ( "Self", PhysicalAttack 1 ) ], ( env, False ) )


handleMove : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove env evnt data basedata =
    let
        newX =
            if basedata.state == EnemyMove then
                if data.x < 400 then
                    data.x + 2

                else
                    data.x

            else if basedata.state == EnemyReturn then
                if data.x > 100 then
                    data.x - 2

                else
                    data.x

            else
                data.x

        ( newBaseData, msg ) =
            if basedata.state == EnemyMove && newX >= 400 then
                ( { basedata | state = EnemyAttack }, [] )

            else if basedata.state == EnemyReturn && newX <= 100 then
                ( { basedata | state = PlayerTurn }, [ Other ( "Self", SwitchTurn ) ] )

            else
                ( basedata, [] )
    in
    ( ( { data | x = newX }, newBaseData ), msg, ( env, False ) )


handleTurn : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleTurn env evnt data basedata =
    if basedata.state == EnemyAttack then
        attackPlayer env evnt data basedata

    else
        handleMove env evnt data basedata


updateOne : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne env evnt data basedata =
    case evnt of
        Tick _ ->
            handleTurn env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
