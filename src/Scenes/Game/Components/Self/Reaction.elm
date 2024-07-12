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
    if char.hp < 0 then
        { char | hp = 0 }

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
getTargetChar data num =
    Maybe.withDefault { defaultSelf | position = 0 } <|
        List.head <|
            List.drop (num - 1) <|
                List.filter (\x -> x.hp /= 0) data


getNewData : List Self -> Self -> List Self
getNewData data newChar =
    List.filter
        (\x -> x.hp /= 0)
    <|
        List.map
            (\x ->
                if x.position == newChar.position then
                    newChar

                else
                    x
            )
            data


findMin : List Self -> Int
findMin data =
    data
        |> List.filter (\x -> x.hp /= 0)
        |> List.map (\x -> x.position)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100


handleAttack : AttackType -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack attackType num env msg data basedata =
    let
        targetChar =
            getHurt attackType <|
                getTargetChar data num

        newData =
            getNewData data targetChar

        remainCharNum =
            ( List.length <| List.filter (\x -> x.position <= 3) newData
            , List.length <| List.filter (\x -> x.position > 3) newData
            )

        newChar =
            if Debug.log "remainSelf" remainCharNum == Debug.log "pre" basedata.selfNum then
                basedata.curChar

            else
                findMin newData

        newMsg =
            if remainCharNum == basedata.selfNum then
                []

            else
                [ Other ( "Enemy", ChangeTarget (Debug.log "newNum" remainCharNum) ) ]
    in
    ( ( newData, { basedata | selfNum = remainCharNum } ), newMsg, env )
