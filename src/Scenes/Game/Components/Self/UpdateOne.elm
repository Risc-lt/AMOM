module Scenes.Game.Components.Self.UpdateOne exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)
import Scenes.Game.Components.Skill.Init exposing (SkillType(..), Range(..))
import Scenes.Game.Components.Skill.Init exposing (defaultSkill)
import Scenes.Game.Components.GenRandom exposing (genRandomNum)


type alias Data =
    Self


handleKeyDown : Int -> List Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleKeyDown key list env evnt data basedata =
    case key of
        13 ->
            if basedata.state == GameBegin then
                ( ( data, { basedata | state = PlayerTurn } ), [ Other ( "Interface", StartGame ) ], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


handleTargetSelection : Float -> Float -> Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleTargetSelection x y self env evnt data basedata =
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
            self.name /= "Bruce"

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
                    if skill.range == Ally && List.member newPosition basedata.selfNum then
                        EnemyMove

                    else
                        basedata.state

                _ ->
                    if List.member position basedata.enemyNum && effective then
                        PlayerAttack

                    else
                        basedata.state

        skillMsg =
            case basedata.state of
                TargetSelection (Skills skill) ->
                    if skill.range == Ally then
                        [ Other ( "Self", Action (PlayerSkill self skill newPosition) ) ]

                    else
                        [ Other ( "Enemy", Action (PlayerSkill self skill position) ) ]

                _ ->
                    []
    in
    ( ( data, { basedata | curEnemy = position, state = newState } )
    , skillMsg ++ [ Other ( "Interface", ChangeStatus (ChangeState newState) ) ]
    , ( env, False )
    )


handleChooseSkill : Float -> Float -> Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleChooseSkill x y self env evnt data basedata =
    let
        ( kind, storage ) =
            if basedata.state == ChooseSpeSkill then
                ( SpecialSkill, self.energy )

            else
                ( Magic, self.mp )

        skills =
            List.sortBy .cost <|
                List.filter (\s -> s.kind == kind) <|
                    self.skills

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
    in
    if skill.cost <= storage && skill.name /= "" then
        case skill.range of
            Oneself ->
                ( ( data, { basedata | state = EnemyMove } )
                , [ Other ( "Self", Action (PlayerSkill self skill 0) ) ]
                , ( env, False )
                )

            AllEnemy ->
                ( ( data, { basedata | state = EnemyMove } )
                , [ Other ( "Enemy", Action (PlayerSkill self skill 0) ) ]
                , ( env, False )
                )

            _ ->
                ( ( data, { basedata | state = TargetSelection (Skills skill) } )
                , [ Other ( "Interface", ChangeStatus (ChangeState (TargetSelection (Skills skill))) ) ]
                , ( env, False )
                )

    else
        ( ( data, basedata ), [], ( env, False ) )


handleMouseDown : Float -> Float -> Data -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMouseDown x y self env evnt data basedata =
    case basedata.state of
        PlayerTurn ->
            let
                action =
                    if x > 320 && x < 540 && y > 680 && y < 1080 then
                        TargetSelection Attack

                    else if x > 760 && x < 980 && y > 680 && y < 1080 then
                        ChooseSpeSkill

                    else if x > 980 && x < 1200 && y > 680 && y < 1080 then
                        ChooseMagic

                    else
                        basedata.state
            in
            ( ( data, { basedata | state = action } )
            , [ Other ( "Interface", ChangeStatus (ChangeState action) ) ]
            , ( env, False )
            )

        TargetSelection _->
            handleTargetSelection x y self env evnt data basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


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
            if basedata.state == PlayerAttack && not longRange then
                if data.x > 670 then
                    data.x - 5

                else
                    670

            else if basedata.state == PlayerReturn || basedata.state == Counter then
                if data.x < returnX then
                    data.x + 5

                else
                    returnX

            else
                data.x

        newBaseData =
            if basedata.state == PlayerReturn && newX >= returnX then
                { basedata | state = EnemyMove }

            else if basedata.state == Counter && newX >= returnX then
                { basedata | state = EnemyAttack }

            else if basedata.state == PlayerAttack && (newX <= 670 || longRange) then
                { basedata | state = PlayerReturn }

            else
                basedata

        turnMsg =
            if basedata.state == Counter && newX >= returnX then
                [ Other ( "Enemy", Action StartCounter ) ]

            else if basedata.state == PlayerReturn && newX >= returnX then
                [ Other ( "Interface", SwitchTurn 0 ) ]

            else
                []

        attackMsg =
            if basedata.state == PlayerAttack && (newX <= 670 || longRange) then
                [ Other ( "Enemy", Action (PlayerNormal data basedata.curEnemy) ) ]

            else
                []
    in
    ( ( { data | x = newX }, newBaseData ), attackMsg ++ turnMsg, ( env, False ) )


updateOne : List Self -> ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne list env evnt data basedata =
    case evnt of
        Tick _ ->
            handleMove list env evnt data basedata

        KeyDown key ->
            if (basedata.state == PlayerTurn && data.x <= 670) || basedata.state == GameBegin then
                handleKeyDown key list env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        MouseUp key ( x, y ) ->
            if key == 0 then
                handleMouseDown x y data env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
