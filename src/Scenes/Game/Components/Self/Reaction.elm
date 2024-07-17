module Scenes.Game.Components.Self.Reaction exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
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


normalAttackDemage : Self -> Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self
normalAttackDemage char enemy env =
    let
        isCritical =
            checkRate env <|
                genCriticalHitRate char

        demage =
            getSpecificNormalAttack char enemy isCritical
    in
    checkHealth <|
        { char | hp = char.hp - demage }


getHurt : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self -> Self
getHurt enemy env char =
    let
        isAvoid =
            checkRate env <|
                genAvoidRate char

        oldAttributes =
            char.attributes

        newAttributes =
            { oldAttributes | energy = oldAttributes.energy + 0.3 }
    in
    if isAvoid then
        char

    else
        case attackType of
            NormalAttack ->
                normalAttackDemage char enemy env

            SpecialSkill ->
                checkHealth <|
                    { char | hp = char.hp - 50, attributes = newAttributes }

            Magic ->
                checkHealth <|
                    { char | hp = char.hp - 50, attributes = newAttributes }


getTargetChar : List Self -> Int -> Self
getTargetChar data num =
    Maybe.withDefault { defaultSelf | position = 0 } <|
        List.head <|
            List.drop (num - 1) <|
                List.filter (\x -> x.hp /= 0) data


getNewData : List Self -> Self -> List Self
getNewData data newChar =
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


handleAttack : Enemy -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack enemy num env msg data basedata =
    let
        targetChar =
            getHurt enemy env <|
                getTargetChar data num

        newData =
            getNewData data targetChar

        remainCharNum =
            ( List.length <| List.filter (\x -> x.position <= 3 && x.hp /= 0) newData
            , List.length <| List.filter (\x -> x.position > 3 && x.hp /= 0) newData
            )

        newRemain =
            [ Other ( "Enemy", ChangeTarget remainCharNum ) ]
    in
    ( ( newData, { basedata | selfNum = remainCharNum } ), newRemain, env )
