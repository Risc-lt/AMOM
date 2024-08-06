module SceneProtos.Game.Components.Enemy.AttackRec2 exposing (getEffect, getSpecificMagicalAttack, handleAttack, handleSkill, skillRec)

{-|


# AttackRec2 module

This module contains the functions that are used to handle the attack and skill of the enemy.

@docs getEffect, getSpecificMagicalAttack, handleAttack, handleSkill, skillRec

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Enemy.AttackRec exposing (Data, attackRec, checkStatus)
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.GenRandom exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Element(..), Range(..), Skill, SpecialType(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time


{-| The initial data for the StroryTrigger component
-}
handleAttack : Self -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack self position env msg data basedata =
    let
        ( newData, isCounter, isAvoid ) =
            attackRec self env data position basedata

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        counterMsg =
            if isCounter then
                [ Other ( "Self", ChangeStatus (ChangeState Counter) ) ]

            else
                []

        avoidMsg =
            if isAvoid then
                []

            else
                [ Other ( "Self", AttackSuccess self.position ) ]

        dieMsg =
            if remainNum == basedata.enemyNum then
                []

            else
                [ Other ( "Self", CharDie remainNum ) ]
    in
    ( ( newData, { basedata | state = PlayerTurn, enemyNum = remainNum, curSelf = self.position, curEnemy = position } )
    , counterMsg ++ avoidMsg ++ dieMsg
    , env
    )


{-| The initial data for the StroryTrigger component
-}
getSpecificMagicalAttack : Enemy -> Self -> Skill -> Int
getSpecificMagicalAttack enemy self skill =
    let
        element =
            if skill.name == "Arcane Beam" then
                case self.name of
                    "Bruce" ->
                        Water

                    "Bulingze" ->
                        Fire

                    _ ->
                        Air

            else
                skill.element

        eleResistance =
            case element of
                Water ->
                    enemy.extendValues.eleResistance.waterResistance

                Fire ->
                    enemy.extendValues.eleResistance.fireResistance

                Air ->
                    enemy.extendValues.eleResistance.airResistance

                Earth ->
                    enemy.extendValues.eleResistance.earthResistance

                None ->
                    0
    in
    floor (toFloat skill.effect.hp * (1 + toFloat self.attributes.intelligence * 0.025) * toFloat (100 - eleResistance) / 100)


{-| The initial data for the StroryTrigger component
-}
getEffect : Self -> Skill -> Messenger.Base.Env SceneCommonData UserData -> Enemy -> BaseData -> Enemy
getEffect self skill env target basedata =
    let
        hpChange =
            if skill.kind == Magic then
                getSpecificMagicalAttack target self skill

            else
                skill.effect.hp

        mpChange =
            skill.effect.mp

        newBuff =
            case List.head skill.buff of
                Nothing ->
                    []

                Just buff ->
                    [ ( buff, skill.lasting ) ]
    in
    checkStatus
        { target
            | hp = target.hp - hpChange
            , mp = target.mp - mpChange
            , buff = newBuff ++ target.buff
        }


{-| The initial data for the StroryTrigger component
-}
skillRec : Self -> Skill -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> BaseData -> Data
skillRec self skill env data position basedata =
    let
        newPosition =
            case skill.range of
                AllFront ->
                    if List.any (\x -> x <= 9) basedata.enemyNum then
                        [ 7, 8, 9 ]

                    else
                        [ 10, 11, 12 ]

                Chain ->
                    case position of
                        7 ->
                            [ 7, 8, 10 ]

                        8 ->
                            [ 7, 8, 9, 11 ]

                        9 ->
                            [ 8, 9, 12 ]

                        10 ->
                            [ 7, 10, 11 ]

                        11 ->
                            [ 8, 10, 11, 12 ]

                        12 ->
                            [ 9, 11, 12 ]

                        _ ->
                            []

                OneTheOther _ ->
                    if position <= 9 then
                        [ 7, 8, 9 ]

                    else
                        [ 10, 11, 12 ]

                Region ->
                    if position <= 9 then
                        [ 7, 8, 9 ]

                    else
                        [ 10, 11, 12 ]

                _ ->
                    [ position ]

        targets =
            List.filter (\x -> List.member x.position newPosition) data

        newTargets =
            if skill.range /= Ally && skill.kind == Magic then
                List.indexedMap Tuple.pair targets
                    |> List.filter
                        (\( index, enemy ) ->
                            checkRate (Time.posixToMillis env.globalData.currentTimeStamp + index) <|
                                (self.extendValues.ratioValues.magicalHitRate
                                    - enemy.extendValues.ratioValues.avoidRate
                                )
                        )
                    |> List.map Tuple.second

            else
                targets
    in
    case skill.range of
        OneTheOther effect ->
            (List.map (\t -> getEffect self skill env t basedata) <|
                List.filter (\t -> t.position == position) newTargets
            )
                ++ (List.map (\t -> getEffect self { skill | buff = [], effect = effect } env t basedata) <|
                        List.filter (\t -> t.position /= position) newTargets
                   )

        _ ->
            List.map (\t -> getEffect self skill env t basedata) newTargets


{-| The initial data for the StroryTrigger component
-}
handleSkill : Self -> Skill -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleSkill self skill position env msg data basedata =
    let
        newEnemies =
            skillRec self skill env data position basedata

        newData =
            List.filter
                (\x -> x.hp /= 0)
            <|
                List.map
                    (\x ->
                        Maybe.withDefault x <|
                            List.head <|
                                List.filter
                                    (\e ->
                                        x.position == e.position
                                    )
                                    newEnemies
                    )
                    data

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        dieMsg =
            if remainNum == basedata.enemyNum then
                []

            else
                [ Other ( "Self", CharDie remainNum ) ]
    in
    ( ( newData, { basedata | enemyNum = remainNum } )
    , dieMsg ++ [ Other ( "Interface", SwitchTurn 1 ), Other ( "StoryTrigger", SwitchTurn 1 ) ]
    , env
    )
