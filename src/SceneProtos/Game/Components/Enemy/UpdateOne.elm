module SceneProtos.Game.Components.Enemy.UpdateOne exposing
    ( Data
    , attackPlayer
    , checkStorage
    , chooseAction
    , chooseSpecial
    , getTarget
    , handleMove
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Scene.Scene exposing (MMsg)
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, State(..))
import SceneProtos.Game.Components.GenRandom exposing (genRandomNum)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..), defaultSkill)
import SceneProtos.Game.Components.Special.Library exposing (getNewBuff)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time


{-| The initial data for the StroryTrigger component
-}
type alias Data =
    Enemy


{-| The initial data for the StroryTrigger component
-}
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


{-| The initial data for the StroryTrigger component
-}
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
            List.drop (index - 1) <|
                List.sort <|
                    basedata.selfNum


{-| The initial data for the StroryTrigger component
-}
attackPlayer : Data -> BaseData -> List (MMsg ComponentTarget ComponentMsg SceneMsg UserData)
attackPlayer data basedata =
    [ Other ( "Self", Action (EnemyNormal data basedata.curSelf) ) ]


{-| The initial data for the StroryTrigger component
-}
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

        newData =
            if basedata.state == EnemyReturn && newX <= returnX then
                if basedata.side == EnemySide then
                    { data | buff = getNewBuff data.buff, state = Rest }

                else
                    { data | buff = getNewBuff data.buff }

            else
                data

        newBaseData =
            if basedata.state == EnemyReturn && newX <= returnX then
                { basedata | state = PlayerTurn }

            else if basedata.state == Counter && newX <= returnX then
                { basedata | state = PlayerAttack False }

            else if basedata.state == EnemyAttack && newX >= 670 then
                { basedata | state = EnemyReturn }

            else
                basedata

        msg =
            if basedata.state == Counter && newX <= returnX then
                [ Other ( "Self", Action StartCounter ) ]

            else if basedata.state == EnemyReturn && newX <= returnX then
                [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]

            else if basedata.state == EnemyAttack && newX >= 670 then
                attackPlayer data basedata

            else
                []
    in
    ( ( { newData | x = newX }, newBaseData ), msg, ( env, False ) )


{-| The initial data for the StroryTrigger component
-}
chooseAction : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
chooseAction env evnt data basedata =
    let
        hasMagic =
            if (List.length <| List.filter (\s -> s.kind == Magic && s.cost <= data.mp) data.skills) /= 0 then
                [ EnemyAttack, ChooseMagic ]

            else
                [ EnemyAttack ]

        hasSpeSkill =
            if (List.length <| List.filter (\s -> s.kind == SpecialSkill && s.cost <= data.energy) data.skills) /= 0 then
                ChooseSpeSkill :: hasMagic

            else
                hasMagic

        hasItem =
            if
                (List.length <| List.filter (\s -> s.kind == Item) data.skills)
                    /= 0
                    && data.hp
                    < data.extendValues.basicStatus.maxHp
                    && data.mp
                    < data.extendValues.basicStatus.maxMp
            then
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


{-| The initial data for the StroryTrigger component
-}
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
                ( ( { newData | buff = getNewBuff newData.buff, state = Rest }, { basedata | state = PlayerTurn } )
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
