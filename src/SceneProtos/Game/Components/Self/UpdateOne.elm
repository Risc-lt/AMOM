module SceneProtos.Game.Components.Self.UpdateOne exposing
    ( Data
    , checkStorage
    , handleChooseSkill
    , handleCompounding
    , handleKeyDown
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Self.AttackRec exposing (checkBuff)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..), defaultSkill)
import SceneProtos.Game.Components.Special.SpeSkill exposing (..)
import SceneProtos.Game.Components.Special.Magic exposing (..)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| The initial data for the StroryTrigger component
-}
type alias Data =
    Self


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
handleKeyDown : Int -> List Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleKeyDown key list env evnt data basedata =
    case key of
        13 ->
            let
                newNum =
                    List.filter
                        (\n ->
                            List.member n <|
                                List.map (\s -> s.position) <|
                                    List.filter (\s -> s.hp /= 0) list
                        )
                        basedata.selfNum
            in
            ( ( data, { basedata | state = PlayerTurn, selfNum = newNum, side = EnemySide } )
            , [ Other ( "Enemy", CharDie newNum ), Other ( "Interface", SwitchTurn 0 ) ]
            , ( env, False )
            )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


{-| The initial data for the StroryTrigger component
-}
handleCompounding : Skill -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleCompounding skill env evnt data basedata =
    let
        newItem =
            if List.any (\s -> s.name == skill.name) data.skills then
                List.map
                    (\s ->
                        if s.name == skill.name then
                            { s | cost = s.cost + 1 }

                        else
                            s
                    )
                    data.skills

            else
                { skill | cost = 1 } :: data.skills

        newBuff =
            checkBuff data
    in
    ( ( checkStorage <|
            { newBuff
                | skills = newItem
                , energy = data.energy - 100
                , state = Rest
            }
      , { basedata | state = EnemyTurn }
      )
    , [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]
    , ( env, False )
    )


{-| Check the index of the skill
-}
checkIndex : Float -> Float -> Int
checkIndex x y =
    if x > 640 && x < 1420 && y > 728 && y < 768 then
        1

    else if x > 640 && x < 1420 && y > 816 && y < 856 then
        2

    else if x > 640 && x < 1420 && y > 904 && y < 944 then
        3

    else if x > 640 && x < 1420 && y > 992 && y < 1032 then
        4

    else
        0


{-| Handle choose skill
-}
handleChooseSkill : Float -> Float -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleChooseSkill x y env evnt data basedata =
    let
        ( kind, storage ) =
            if basedata.state == ChooseSpeSkill then
                ( SpecialSkill, data.energy )

            else if basedata.state == ChooseMagic then
                ( Magic, data.mp )

            else
                ( Item, 100 )

        skills =
            let
                targets =
                    List.sortBy .cost <|
                        List.filter (\s -> s.kind == kind) <|
                            data.skills

                addPoison =
                    if List.any (\i -> i.name == "Poison") targets then
                        targets

                    else
                        targets ++ [ poison ]

                addMagicWater =
                    if List.any (\i -> i.name == "Magic Water") targets then
                        addPoison

                    else
                        addPoison ++ [ magicWater ]
            in
            if basedata.state == Compounding then
                addMagicWater

            else
                targets

        index =
            checkIndex x y

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
    if basedata.state /= Compounding then
        handeleNotCompounding storage newData skill env evnt data basedata

    else
        handleCompounding skill env evnt data basedata


{-| Handle the case when the skill is not compounding
-}
handeleNotCompounding : Int -> Data -> Skill -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handeleNotCompounding storage newData skill env evnt data basedata =
    if skill.cost <= storage && skill.name /= "" then
        case skill.range of
            Oneself ->
                if skill.name == "Compounding" then
                    ( ( data, { basedata | state = Compounding } )
                    , [ Other ( "Interface", ChangeStatus (ChangeState Compounding) ) ]
                    , ( env, False )
                    )

                else
                    let
                        newBuff =
                            checkBuff newData
                    in
                    ( ( { newBuff | state = Rest }, { basedata | state = EnemyTurn } )
                    , [ Other ( "Self", Action (PlayerSkill data skill data.position) ) ]
                    , ( env, False )
                    )

            AllFront ->
                let
                    newBuff =
                        checkBuff newData
                in
                ( ( { newBuff | state = Rest }, { basedata | state = EnemyTurn } )
                , [ Other ( "Enemy", Action (PlayerSkill data skill 0) ) ]
                , ( env, False )
                )

            _ ->
                ( ( data, { basedata | state = TargetSelection (Skills skill) } )
                , [ Other ( "Interface", ChangeStatus (ChangeState (TargetSelection (Skills skill))) ) ]
                , ( env, False )
                )

    else
        ( ( data, basedata ), [], ( env, False ) )
