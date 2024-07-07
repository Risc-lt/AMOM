module Scenes.Game.Components.Self.Reaction exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Self


checkHealth : Self -> Self
checkHealth char =
    if char.hp <= 0 then
        { char | hp = 0, state = Dead }

    else
        char


getHurt : AttackType -> Self -> Self
getHurt attackType char =
    case attackType of
        Physical ->
            checkHealth <|
                { char | hp = char.hp - 50 * (100 - char.phyDefence) / 100 }

        Magical ->
            checkHealth <|
                { char | hp = char.hp - 50 * (100 - char.magDefence) / 100 }


getTargetChar : List Self -> Int -> Self
getTargetChar data id =
    Maybe.withDefault { defaultSelf | id = 0 } <|
        List.head <|
            List.filter (\x -> x.id == id) data


getNewData : List Self -> Self -> List Self
getNewData data newChar =
    List.filter
        (\x -> x.state /= Dead)
    <|
        List.map
            (\x ->
                if x.id == newChar.id then
                    newChar

                else
                    x
            )
            data


findMin : List Self -> Int
findMin data =
    data
        |> List.map (\x -> x.id)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100


handleAttack : AttackType -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack attackType id env msg data basedata =
    let
        targetChar =
            getHurt attackType <|
                getTargetChar data id

        newData =
            getNewData data targetChar

        remainCharNum =
            List.length <| newData

        newChar =
            if Debug.log "remainSelf" remainCharNum == Debug.log "pre" basedata.selfNum then
                basedata.curChar

            else
                findMin newData

        newMsg =
            if remainCharNum == basedata.selfNum then
                []

            else
                [ Other ( "Enemy", ChangeTarget (Debug.log "newChar" newChar) ) ]
    in
    ( ( newData, { basedata | selfNum = remainCharNum, curChar = newChar } ), newMsg, env )
