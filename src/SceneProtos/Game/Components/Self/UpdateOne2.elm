module SceneProtos.Game.Components.Self.UpdateOne2 exposing
    ( handleMouseDown
    , handleTargetSelection
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Self.AttackRec exposing (checkBuff)
import SceneProtos.Game.Components.Self.Init exposing (State(..))
import SceneProtos.Game.Components.Self.UpdateOne exposing (Data, checkStorage, handleChooseSkill)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..))
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (..)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| Check the position of the target
-}
checkPosition : Float -> Float -> Int
checkPosition x y =
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


{-| Get the new position of the target
-}
getNewPos : Int -> Int
getNewPos pos =
    case pos of
        7 ->
            4

        8 ->
            5

        9 ->
            6

        10 ->
            1

        11 ->
            2

        12 ->
            3

        _ ->
            0


{-| Update the data
-}
updateData : Data -> BaseData -> Gamestate -> List Skill -> Data
updateData data basedata newState newItem =
    if basedata.state /= newState then
        case basedata.state of
            TargetSelection (Skills skill) ->
                if skill.kind == SpecialSkill then
                    checkStorage <|
                        { data
                            | energy = data.energy - skill.cost
                            , buff = getNewBuff data.buff
                            , state = Rest
                        }

                else if skill.kind == Magic then
                    checkStorage <|
                        { data
                            | mp = data.mp - skill.cost
                            , buff = getNewBuff data.buff
                            , state = Rest
                        }

                else
                    checkStorage <|
                        { data
                            | skills = newItem
                            , buff = getNewBuff data.buff
                            , state = Rest
                        }

            _ ->
                data

    else
        data


{-| The initial data for the StroryTrigger component
-}
handleTargetSelection : Float -> Float -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleTargetSelection x y env evnt data basedata =
    let
        position =
            checkPosition x y

        newPosition =
            getNewPos position

        melee =
            data.name /= "Bruce"

        front =
            List.any (\p -> p <= 9) basedata.enemyNum

        effective =
            if melee && front && position > 9 then
                False

            else
                True

        newState =
            case basedata.state of
                TargetSelection (Skills skill) ->
                    if
                        skill.range
                            == Ally
                            && List.member newPosition basedata.selfNum
                            || skill.range
                            /= Ally
                            && List.member position basedata.enemyNum
                    then
                        EnemyTurn

                    else
                        basedata.state

                _ ->
                    if List.member position basedata.enemyNum && effective then
                        PlayerAttack <| List.any (\( b, _ ) -> b == ExtraAttack) data.buff

                    else
                        basedata.state

        skillMsg =
            if basedata.state /= newState then
                case basedata.state of
                    TargetSelection (Skills skill) ->
                        if skill.range == Ally then
                            [ Other ( "Self", Action (PlayerSkill data skill newPosition) ) ]

                        else
                            [ Other ( "Enemy", Action (PlayerSkill data skill position) ) ]

                    _ ->
                        []

            else
                []

        newItem =
            case basedata.state of
                TargetSelection (Skills skill) ->
                    if skill.kind == Item then
                        List.map
                            (\s ->
                                if s.name == skill.name then
                                    { s | cost = s.cost - 1 }

                                else
                                    s
                            )
                            data.skills

                    else
                        data.skills

                _ ->
                    data.skills

        newData =
            updateData data basedata newState newItem
    in
    ( ( newData, { basedata | curEnemy = position, state = newState } )
    , skillMsg ++ [ Other ( "Interface", ChangeStatus (ChangeState newState) ) ]
    , ( env, False )
    )


{-| The initial data for the StroryTrigger component
-}
handleMouseDown : Float -> Float -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMouseDown x y env evnt data basedata =
    case basedata.state of
        PlayerTurn ->
            let
                action =
                    if x > 320 && x < 540 && y > 680 && y < 1080 then
                        TargetSelection Attack

                    else if x > 540 && x < 760 && y > 680 && y < 1080 then
                        EnemyTurn

                    else if x > 760 && x < 980 && y > 680 && y < 1080 then
                        ChooseSpeSkill

                    else if x > 980 && x < 1200 && y > 680 && y < 1080 then
                        ChooseMagic

                    else if x > 1200 && x < 1420 && y > 680 && y < 1080 then
                        ChooseItem

                    else
                        basedata.state

                newData =
                    if action == EnemyTurn then
                        checkBuff <|
                            { data | buff = ( DefenceUp 50, 2 ) :: data.buff, state = Rest }

                    else
                        data

                msg =
                    if action == EnemyTurn then
                        [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]

                    else
                        [ Other ( "Interface", ChangeStatus (ChangeState action) ) ]
            in
            ( ( newData, { basedata | state = action } )
            , msg
            , ( env, False )
            )

        TargetSelection _ ->
            handleTargetSelection x y env evnt data basedata

        ChooseMagic ->
            handleChooseSkill x y env evnt data basedata

        ChooseSpeSkill ->
            handleChooseSkill x y env evnt data basedata

        ChooseItem ->
            handleChooseSkill x y env evnt data basedata

        Compounding ->
            handleChooseSkill x y env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
