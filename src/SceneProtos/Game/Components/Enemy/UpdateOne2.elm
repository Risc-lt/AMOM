module SceneProtos.Game.Components.Enemy.UpdateOne2 exposing
    ( handleSpecial
    , handleTurn
    , updateOne
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Enemy.Init exposing (State(..))
import SceneProtos.Game.Components.Enemy.UpdateOne exposing (Data, checkStorage, chooseAction, chooseSpecial, getTarget, handleMove)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..))
import SceneProtos.Game.Components.Special.Library exposing (getNewBuff)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| The initial data for the StroryTrigger component
-}
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
            if
                skill.range
                    == Ally
                    && List.member newPosition basedata.enemyNum
                    || skill.range
                    /= Ally
                    && List.member position basedata.selfNum
            then
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

            else
                data
    in
    ( ( newData, { basedata | curSelf = position, state = newState } )
    , skillMsg
    , ( env, False )
    )


{-| The initial data for the StroryTrigger component
-}
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


{-| The initial data for the StroryTrigger component
-}
updateOne : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateOne env evnt data basedata =
    case evnt of
        Tick _ ->
            let
                returnX =
                    if data.position <= 9 then
                        235

                    else
                        105

                newData =
                    if data.x <= returnX then
                        { data | isRunning = False }

                    else
                        { data | isRunning = True }
            in
            if data.state == Rest && basedata.side == EnemySide then
                ( ( newData, { basedata | state = PlayerTurn } )
                , [ Other ( "Interface", SwitchTurn 1 ), Other ( "StoryTrigger", SwitchTurn 1 ) ]
                , ( env, False )
                )

            else if List.any (\( b, _ ) -> b == NoAction) newData.buff then
                ( ( { newData | buff = getNewBuff newData.buff, state = Rest }, { basedata | state = PlayerTurn } )
                , [ Other ( "Interface", SwitchTurn 1 ), Other ( "StoryTrigger", SwitchTurn 1 ) ]
                , ( env, False )
                )

            else
                handleTurn env evnt newData basedata

        _ ->
            ( ( data, basedata ), [], ( env, False ) )
