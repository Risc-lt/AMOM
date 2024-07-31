module SceneProtos.Game.Components.Self.UpdateOne3 exposing
    ( handleMove
    , updateOne
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Self.AttackRec exposing (checkBuff)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.Components.Self.UpdateOne exposing (Data, handleKeyDown)
import SceneProtos.Game.Components.Self.UpdateOne2 exposing (handleMouseDown)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), SpecialType(..))
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.Special.Library2 exposing (..)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| The initial data for the StroryTrigger component
-}
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


{-| The initial data for the StroryTrigger component
-}
moveX : Data -> BaseData -> Bool -> Float -> Float
moveX data basedata longRange returnX =
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


{-| Update the basedata
-}
getNewBaseData : BaseData -> Float -> Float -> Bool -> BaseData
getNewBaseData basedata newX returnX longRange =
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


getMsg : Data -> BaseData -> Float -> Float -> Bool -> List (Msg String ComponentMsg sommsg)
getMsg data basedata newX returnX longRange =
    let
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
    attackMsg ++ turnMsg


{-| The initial data for the StroryTrigger component
-}
handleMove : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleMove env evnt data basedata =
    let
        returnX =
            if data.position <= 3 then
                1100

            else
                1220

        longRange =
            data.name == "Bruce"

        newX =
            moveX data basedata longRange returnX

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
            getNewBaseData basedata newX returnX longRange

        newMsg =
            getMsg data basedata newX returnX longRange
    in
    ( ( { newData | x = newX, isRunning = runFlag }, newBaseData ), newMsg, ( env, False ) )


{-| The initial data for the StroryTrigger component
-}
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
                handleMove env evnt data basedata

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
