module Scenes.Game.Components.Enemy.UpdateOne exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Random
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.SceneBase exposing (SceneCommonData)
import Time


type alias Data =
    Enemy


attackMsg : Data -> BaseData -> Env cdata userdata -> Msg String ComponentMsg sommsg
attackMsg data basedata env =
    let
        front =
            List.filter (\x -> x <= 3) basedata.selfNum
    in
    Other
        ( "Self"
        , Action <|
            (EnemyNormal data <|
                Tuple.first <|
                    Random.step
                        (Random.int 1
                            (if List.length front == 0 then
                                List.length basedata.selfNum

                             else
                                List.length front
                            )
                        )
                    <|
                        Random.initialSeed <|
                            Time.posixToMillis env.globalData.currentTimeStamp
            )
                False
        )


attackPlayer : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
attackPlayer env evnt data basedata =
    ( ( data, { basedata | state = EnemyReturn } )
    , [ attackMsg data basedata env ]
    , ( env, False )
    )


handleMove : List Enemy -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove list env evnt data basedata =
    let
        returnX =
            if data.position <= 9 then
                230

            else
                100

        newX =
            if basedata.state == EnemyMove then
                if data.x + 5 < 670 then
                    data.x + 5

                else
                    670

            else if basedata.state == EnemyReturn then
                if data.x - 5 > returnX then
                    data.x - 5

                else
                    returnX

            else
                data.x

        ( newBaseData, msg ) =
            if basedata.state == EnemyMove && newX >= 670 then
                ( { basedata | state = EnemyAttack }, [] )

            else if basedata.state == EnemyReturn && newX <= returnX then
                ( { basedata | state = PlayerTurn }, [ Other ( "Interface", SwitchTurn 1 ) ] )

            else
                ( basedata, [] )
    in
    ( ( { data | x = newX }, newBaseData ), msg, ( env, False ) )


handleTurn : List Enemy -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleTurn list env evnt data basedata =
    if basedata.state == EnemyAttack then
        attackPlayer env evnt data basedata

    else
        handleMove list env evnt data basedata


updateOne : List Enemy -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne list env evnt data basedata =
    case evnt of
        Tick _ ->
            handleTurn list env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
