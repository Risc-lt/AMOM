module SceneProtos.Game.Components.Self.AttackRec2 exposing
    ( getEffect
    , getSpecificMagicalAttack
    , handleAttack
    , handleSkill
    , skillRec
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.GenRandom exposing (..)
import SceneProtos.Game.Components.Self.AttackRec exposing (Data, attackRec, checkStatus)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Element(..), Range(..), Skill, SpecialType(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time


{-| The initial data for the StroryTrigger component
-}
handleAttack : Enemy -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack enemy position env msg data basedata =
    let
        ( newData, isCounter, isAvoid ) =
            attackRec enemy env data position basedata

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        counterMsg =
            if isCounter then
                [ Other ( "Enemy", ChangeStatus (ChangeState Counter) ) ]

            else
                []

        avoidMsg =
            if isAvoid then
                []

            else
                [ Other ( "Enemy", AttackSuccess enemy.position ) ]

        dieMsg =
            if remainNum == basedata.selfNum then
                []

            else
                [ Other ( "Enemy", CharDie remainNum ) ]
    in
    ( ( newData, { basedata | state = EnemyTurn, selfNum = remainNum, curSelf = position, curEnemy = enemy.position } )
    , counterMsg ++ avoidMsg ++ dieMsg
    , env
    )


{-| The initial data for the StroryTrigger component
-}
getSpecificMagicalAttack : Self -> Enemy -> Skill -> Int
getSpecificMagicalAttack self enemy skill =
    let
        element =
            if skill.name == "Arcane Beam" then
                case enemy.name of
                    "Concert" ->
                        Fire

                    _ ->
                        Air

            else
                skill.element

        eleResistance =
            case element of
                Water ->
                    self.extendValues.eleResistance.waterResistance

                Fire ->
                    self.extendValues.eleResistance.fireResistance

                Air ->
                    self.extendValues.eleResistance.airResistance

                Earth ->
                    self.extendValues.eleResistance.earthResistance

                None ->
                    0
    in
    floor (toFloat skill.effect.hp * (1 + toFloat enemy.attributes.intelligence * 0.025) * toFloat (100 - eleResistance) / 100)


{-| The initial data for the StroryTrigger component
-}
getEffect : Enemy -> Skill -> Messenger.Base.Env SceneCommonData UserData -> Self -> BaseData -> Self
getEffect enemy skill env target basedata =
    let
        hpChange =
            if skill.kind == Magic then
                getSpecificMagicalAttack target enemy skill

            else if
                (skill.name
                    == "Poison"
                    || skill.name
                    == "Restoration Potion"
                )
                    && target.name
                    /= "Cavalry"
            then
                -skill.effect.hp

            else
                skill.effect.hp

        mpChange =
            skill.effect.mp

        energyChange =
            skill.effect.energy

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
            , energy = target.energy - energyChange
            , buff = newBuff ++ target.buff
        }


{-| The initial data for the StroryTrigger component
-}
skillRec : Enemy -> Skill -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> BaseData -> Data
skillRec enemy skill env data position basedata =
    let
        newPosition =
            case skill.range of
                Chain ->
                    case position of
                        1 ->
                            [ 1, 2, 4 ]

                        2 ->
                            [ 1, 2, 3, 5 ]

                        3 ->
                            [ 2, 3, 6 ]

                        4 ->
                            [ 1, 4, 5 ]

                        5 ->
                            [ 2, 4, 5, 6 ]

                        6 ->
                            [ 3, 5, 6 ]

                        _ ->
                            []

                Region ->
                    if position <= 3 then
                        [ 1, 2, 3 ]

                    else
                        [ 4, 5, 6 ]

                AllEnemy ->
                    [ 1, 2, 3, 4, 5, 6 ]

                PenetrateOne ->
                    if position <= 3 then
                        [ position, position + 3 ]

                    else
                        [ position - 3, position ]

                _ ->
                    [ position ]

        targets =
            List.filter (\x -> List.member x.position newPosition) data

        newTargets =
            if skill.range /= Ally && skill.kind == Magic then
                List.indexedMap Tuple.pair targets
                    |> List.filter
                        (\( index, self ) ->
                            checkRate (Time.posixToMillis env.globalData.currentTimeStamp + index) <|
                                (enemy.extendValues.ratioValues.magicalHitRate
                                    - self.extendValues.ratioValues.avoidRate
                                )
                        )
                    |> List.map Tuple.second

            else
                targets
    in
    List.map (\t -> getEffect enemy skill env t basedata) newTargets


{-| The initial data for the StroryTrigger component
-}
handleSkill : Enemy -> Skill -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleSkill enemy skill position env msg data basedata =
    let
        newSelfs =
            skillRec enemy skill env data position basedata

        newData =
            List.map
                (\x ->
                    Maybe.withDefault x <|
                        List.head <|
                            List.filter
                                (\e ->
                                    x.position == e.position
                                )
                                newSelfs
                )
                data

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        dieMsg =
            if remainNum == basedata.selfNum then
                []

            else
                [ Other ( "Enemy", CharDie remainNum ) ]
    in
    ( ( newData, { basedata | selfNum = remainNum } )
    , dieMsg ++ [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]
    , env
    )
