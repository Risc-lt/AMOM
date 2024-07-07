module Scenes.Game.Components.Enemy.AttackRec exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.Self.Init exposing (State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Enemy


attackRec : Data -> Int -> Data
attackRec allEnemy id =
    let
        targetEnemy =
            Maybe.withDefault { defaultEnemy | id = 0 } <|
                List.head <|
                    List.filter (\x -> x.id == id) allEnemy

        newEnemy =
            if targetEnemy.hp >= 10 then
                { targetEnemy | hp = targetEnemy.hp - 10 }

            else
                targetEnemy

        newData =
            List.filter
                (\x -> x.hp /= 0)
            <|
                List.map
                    (\x ->
                        if x.id == id then
                            newEnemy

                        else
                            x
                    )
                    allEnemy
    in
    newData


handleAttack : Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack id env msg data basedata =
    let
        newData =
            attackRec data id

        remainNum =
            List.length newData

        newEnemy =
            if remainNum == basedata.enemyNum then
                basedata.curEnemy

            else
                newData
                    |> List.map (\x -> x.id)
                    |> List.sort
                    |> List.head
                    |> Maybe.withDefault 100

        newMsg =
            if remainNum == basedata.enemyNum then
                []

            else
                [ Other ( "Self", ChangeTarget newEnemy ) ]
    in
    ( ( newData, { basedata | enemyNum = remainNum, curEnemy = newEnemy } ), newMsg, env )
