module SceneProtos.Game.Components.Self.UpdateOne exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.GenRandom exposing (genRandomNum)
import SceneProtos.Game.Components.Self.AttackRec exposing (checkBuff)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..), defaultSkill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Self


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


handleKeyDown : Int -> List Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleKeyDown key list env evnt data basedata =
    case key of
        13 ->
            ( ( data, { basedata | state = PlayerTurn, side = EnemySide } )
            , [ Other ( "Interface", SwitchTurn 0 ) ]
            , ( env, False )
            )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


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

    else
        handleCompounding skill env evnt data basedata


handleTargetSelection : Float -> Float -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleTargetSelection x y env evnt data basedata =
    let
        position =
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

        newPosition =
            case position of
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
    in
    ( ( newData, { basedata | curEnemy = position, state = newState } )
    , skillMsg ++ [ Other ( "Interface", ChangeStatus (ChangeState newState) ) ]
    , ( env, False )
    )


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


handleBack : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleBack env evnt data basedata =
    let
        newState =
            case basedata.state of
                TargetSelection Attack ->
                    PlayerTurn

                TargetSelection (Skills skill) ->
                    if skill.kind == Magic then
                        ChooseMagic

                    else if skill.kind == SpecialSkill then
                        ChooseSpeSkill

                    else
                        ChooseItem

                ChooseMagic ->
                    PlayerTurn

                ChooseSpeSkill ->
                    PlayerTurn

                ChooseItem ->
                    PlayerTurn

                Compounding ->
                    ChooseSpeSkill

                _ ->
                    basedata.state
    in
    ( ( data, { basedata | state = newState } )
    , [ Other ( "Interface", ChangeStatus (ChangeState newState) ) ]
    , ( env, False )
    )


handleMove : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove list env evnt data basedata =
    let
        returnX =
            if data.position <= 3 then
                1100

            else
                1220

        longRange =
            data.name == "Bruce"

        newX =
            if
                basedata.state
                    == PlayerAttack True
                    || basedata.state
                    == PlayerAttack False
                    && not longRange
            then
                if data.x > 670 then
                    data.x - 5

                else
                    670

            else if
                basedata.state
                    == PlayerReturn True
                    || basedata.state
                    == PlayerReturn False
                    || basedata.state
                    == Counter
            then
                if data.x < returnX then
                    data.x + 5

                else
                    returnX

            else
                data.x

        runFlag =
            if longRange && basedata.state == TargetSelection Attack then
                True

            else if newX == 670 || newX == returnX then
                False

            else
                True

        newData =
            if basedata.state == PlayerReturn False && newX >= returnX then
                if basedata.side == PlayerSide then
                    let
                        newBuff =
                            checkBuff data
                    in
                    { newBuff | state = Rest }

                else
                    checkBuff data

            else
                data

        newBaseData =
            if basedata.state == PlayerReturn False && newX >= returnX then
                { basedata | state = EnemyTurn }

            else if basedata.state == PlayerReturn True && newX >= returnX then
                { basedata | state = PlayerAttack False }

            else if basedata.state == Counter && newX >= returnX then
                { basedata | state = EnemyAttack }

            else if basedata.state == PlayerAttack False && (newX <= 670 || longRange) then
                { basedata | state = PlayerReturn False }

            else if basedata.state == PlayerAttack True && (newX <= 670 || longRange) then
                { basedata | state = PlayerReturn True }

            else
                basedata

        turnMsg =
            if basedata.state == Counter && newX >= returnX then
                [ Other ( "Enemy", Action StartCounter ) ]

            else if basedata.state == PlayerReturn False && newX >= returnX then
                [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]

            else
                []

        attackMsg =
            if
                (basedata.state == PlayerAttack True || basedata.state == PlayerAttack False)
                    && (newX <= 670 || longRange)
            then
                [ Other ( "Enemy", Action (PlayerNormal data basedata.curEnemy) ) ]

            else
                []
    in
    ( ( { newData | x = newX, isRunning = runFlag }, newBaseData ), attackMsg ++ turnMsg, ( env, False ) )


updateOne : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne list env evnt data basedata =
    case evnt of
        Tick _ ->
            if data.state == Rest && basedata.side == PlayerSide then
                ( ( data, { basedata | state = EnemyTurn } )
                , [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]
                , ( env, False )
                )

            else if List.any (\( b, _ ) -> b == NoAction) data.buff then
                ( ( checkBuff data, { basedata | state = EnemyTurn } )
                , [ Other ( "Interface", SwitchTurn 0 ), Other ( "StoryTrigger", SwitchTurn 0 ) ]
                , ( env, False )
                )

            else
                handleMove list env evnt data basedata

        KeyDown key ->
            if basedata.state == GameBegin then
                handleKeyDown key list env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        MouseUp key ( x, y ) ->
            if key == 0 then
                handleMouseDown x y env evnt data basedata

            else if key == 2 then
                handleBack env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
