module Scenes.Game.Components.Enemy.UpdateOne exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Scene.Scene exposing (MMsg)
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.GenRandom exposing (genRandomNum)
import Scenes.Game.Components.Special.Init exposing (Range(..), Skill, SpecialType(..), defaultSkill)
import Scenes.Game.SceneBase exposing (SceneCommonData)
import Time
import Scenes.Game.Components.Special.Library exposing (getNewBuff)


type alias Data =
    Enemy


checkStorage : Data -> Data
checkStorage data =
    let
        mpCheck =
            if data.mp < 0 then
                { data | mp = 0 }

            else
                data

        energyCheck =
            if data.mp < 0 then
                { mpCheck | energy = 0 }

            else
                mpCheck

        itemCheck =
            List.filter
                (\x ->
                    x.cost /= 0 || x.kind /= Item
                )
                energyCheck.skills
    in
    { energyCheck | skills = itemCheck }


getTarget : BaseData -> Env cdata userdata -> Skill -> Int
getTarget basedata env skill =
    let
        front =
            List.filter (\x -> x <= 3) basedata.selfNum

        upperbound =
            if skill.name == "" then
                if List.length front == 0 then
                    List.length basedata.selfNum

                else
                    List.length front

            else
                List.length basedata.selfNum

        index =
            genRandomNum 1 upperbound <|
                Time.posixToMillis env.globalData.currentTimeStamp
    in
    Maybe.withDefault 100 <|
        List.head <|
            List.drop (index - 1) basedata.selfNum


attackPlayer : Data -> BaseData -> List (MMsg ComponentTarget ComponentMsg SceneMsg UserData)
attackPlayer data basedata =
    [ Other ( "Self", Action (EnemyNormal data basedata.curSelf) ) ]


handleMove : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove env evnt data basedata =
    let
        returnX =
            if data.position <= 9 then
                230

            else
                100

        newX =
            if basedata.state == EnemyAttack then
                if data.x + 5 < 670 then
                    data.x + 5

                else
                    670

            else if basedata.state == EnemyReturn || basedata.state == Counter then
                if data.x - 5 > returnX then
                    data.x - 5

                else
                    returnX

            else
                data.x

        newBuff =
            if basedata.state == EnemyReturn && newX >= returnX then
                getNewBuff data.buff

            else
                data.buff

        newBaseData =
            if basedata.state == EnemyReturn && newX <= returnX then
                { basedata | state = PlayerTurn }

            else if basedata.state == Counter && newX <= returnX then
                { basedata | state = PlayerAttack }

            else if basedata.state == EnemyAttack && newX >= 670 then
                { basedata | state = EnemyReturn }

            else
                basedata

        msg =
            if basedata.state == Counter && newX <= returnX then
                [ Other ( "Self", Action StartCounter ) ]

            else if basedata.state == EnemyReturn && newX <= returnX then
                [ Other ( "Interface", SwitchTurn 0 ) ]

            else if basedata.state == EnemyAttack && newX >= 670 then
                attackPlayer data basedata

            else
                []
    in
    ( ( { data | x = newX, buff = newBuff }, newBaseData ), msg, ( env, False ) )


chooseAction : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
chooseAction env evnt data basedata =
    let
        hasMagic =
            if (List.length <| List.filter (\s -> s.kind == Magic) data.skills) /= 0 then
                [ EnemyAttack, ChooseMagic ]

            else
                [ EnemyAttack ]

        hasSpeSkill =
            if (List.length <| List.filter (\s -> s.kind == SpecialSkill) data.skills) /= 0 then
                ChooseSpeSkill :: hasMagic

            else
                hasMagic

        hasItem =
            if (List.length <| List.filter (\s -> s.kind == Item) data.skills) /= 0 then
                ChooseItem :: hasSpeSkill

            else
                hasSpeSkill

        index =
            Time.posixToMillis env.globalData.currentTimeStamp
                |> genRandomNum 1 (List.length hasItem)

        newState =
            List.drop (index - 1) hasItem
                |> List.head
                |> Maybe.withDefault GameBegin

        newBasedata =
            if newState == EnemyAttack then
                { basedata | state = newState, curSelf = getTarget basedata env defaultSkill }

            else
                { basedata | state = newState }
    in
    ( ( data, newBasedata ), [], ( env, False ) )


chooseSpecial : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
chooseSpecial env evnt data basedata =
    let
        ( kind, storage ) =
            if basedata.state == ChooseSpeSkill then
                ( SpecialSkill, data.energy )

            else if basedata.state == ChooseMagic then
                ( Magic, data.mp )

            else
                ( Item, 100 )

        skills =
            List.sortBy .cost <|
                List.filter (\s -> s.kind == kind) <|
                    data.skills

        index =
            Time.posixToMillis env.globalData.currentTimeStamp
                |> genRandomNum 1 (List.length skills)

        skill =
            if index /= 0 then
                Maybe.withDefault defaultSkill <|
                    List.head <|
                        List.drop (index - 1) skills

            else
                defaultSkill

        newData =
            if skill.kind == SpecialSkill then
                checkStorage <| { data | energy = data.energy - skill.cost }

            else
                checkStorage <| { data | mp = data.mp - skill.cost }
    in
    if skill.cost <= storage && skill.name /= "" then
        case skill.range of
            AllEnemy ->
                ( ( { newData | buff = getNewBuff newData.buff }, { basedata | state = PlayerTurn } )
                , [ Other ( "Self", Action (EnemySkill data skill 0) ) ]
                , ( env, False )
                )

            _ ->
                ( ( data, { basedata | state = TargetSelection (Skills skill) } )
                , []
                , ( env, False )
                )

    else
        ( ( data, basedata ), [], ( env, False ) )


handleSpecial : Skill -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleSpecial skill env evnt data basedata =
    let
        position =
            getTarget basedata env skill

        newPosition =
            case position of
                4 ->
                    7

                5 ->
                    8

                6 ->
                    9

                1 ->
                    10

                2 ->
                    11

                3 ->
                    12

                _ ->
                    0

        newState =
            if skill.range == Ally && List.member newPosition basedata.enemyNum then
                PlayerTurn

            else
                basedata.state

        skillMsg =
            if basedata.state /= newState then
                if skill.range == Ally then
                    [ Other ( "Enemy", Action (EnemySkill data skill newPosition) ) ]

                else
                    [ Other ( "Self", Action (EnemySkill data skill position) ) ]

            else
                []

        newItem =
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

        newData =
            if basedata.state /= newState then
                if skill.kind == SpecialSkill then
                    checkStorage <| 
                        { data 
                        | energy = data.energy - skill.cost 
                        , buff = getNewBuff data.buff 
                        }

                else if skill.kind == Magic then
                    checkStorage <| 
                        { data 
                        | mp = data.mp - skill.cost 
                        , buff = getNewBuff data.buff 
                        }

                else
                    checkStorage <| 
                        { data 
                        | skills = newItem 
                        , buff = getNewBuff data.buff 
                        }

            else
                data
    in
    ( ( newData, { basedata | curEnemy = position, state = newState } )
    , skillMsg ++ [ Other ( "Interface", ChangeStatus (ChangeState newState) ) ]
    , ( env, False )
    )


handleTurn : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleTurn env evnt data basedata =
    case basedata.state of
        EnemyTurn ->
            chooseAction env evnt data basedata

        EnemyAttack ->
            handleMove env evnt data basedata

        EnemyReturn ->
            handleMove env evnt data basedata

        Counter ->
            handleMove env evnt data basedata

        ChooseSpeSkill ->
            chooseSpecial env evnt data basedata

        ChooseMagic ->
            chooseSpecial env evnt data basedata

        ChooseItem ->
            chooseSpecial env evnt data basedata

        TargetSelection (Skills skill) ->
            handleSpecial skill env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updateOne : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne env evnt data basedata =
    case evnt of
        Tick _ ->
            handleTurn env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
