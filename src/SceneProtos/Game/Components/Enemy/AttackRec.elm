module Scenes.Game.Components.Enemy.AttackRec exposing (..)

import Energy exposing (Energy)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenRandom exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Element(..), Range(..), Skill, SpecialType(..))
import SceneProtos.Game.Components.Special.Library exposing (getNewBuff)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time


type alias Data =
    List Enemy


checkStatus : Enemy -> Enemy
checkStatus enemy =
    let
        lowHpCheck =
            if enemy.hp < 0 then
                { enemy | hp = 0 }

            else
                enemy

        highHpCheck =
            if enemy.hp > enemy.extendValues.basicStatus.maxHp then
                { lowHpCheck | hp = enemy.extendValues.basicStatus.maxHp }

            else
                lowHpCheck

        mpCheck =
            if enemy.mp > enemy.extendValues.basicStatus.maxMp then
                { highHpCheck | mp = enemy.extendValues.basicStatus.maxMp }

            else
                highHpCheck

        energyCheck =
            if enemy.energy > 300 then
                { mpCheck | energy = 300 }

            else
                mpCheck
    in
    energyCheck


normalAttackDemage : Enemy -> Self -> Messenger.Base.Env SceneCommonData UserData -> Enemy
normalAttackDemage enemy self env =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isCritical =
            checkRate time enemy.extendValues.ratioValues.criticalHitRate

        damage =
            getSpecificNormalAttack enemy self isCritical

        newEnergy =
            if enemy.energy + 30 > 300 then
                300

            else
                enemy.energy + 30
    in
    checkStatus <|
        { enemy | hp = enemy.hp - damage, energy = newEnergy }


getSpecificNormalAttack : Enemy -> Self -> Bool -> Int
getSpecificNormalAttack enemy self isCritical =
    let
        criticalHitRate =
            if isCritical then
                1.5

            else
                1

        attackUp =
            List.sum <|
                List.map
                    (\( b, _ ) ->
                        case b of
                            AttackUp value ->
                                value

                            _ ->
                                0
                    )
                    self.buff

        defenceUp =
            List.sum <|
                List.map
                    (\( b, _ ) ->
                        case b of
                            DefenceUp value ->
                                value

                            _ ->
                                0
                    )
                    enemy.buff
    in
    floor <|
        (20
            * toFloat enemy.attributes.strength
            / toFloat self.attributes.constitution
            * criticalHitRate
            * toFloat (100 + attackUp - defenceUp)
            / 100
        )


getHurt : Self -> Messenger.Base.Env SceneCommonData UserData -> Enemy -> ( Enemy, Bool )
getHurt self env enemy =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        hitRateUp =
            List.sum <|
                List.map
                    (\( b, _ ) ->
                        case b of
                            HitRateUp value ->
                                value

                            _ ->
                                0
                    )
                    self.buff

        isAvoid =
            not <|
                checkRate time <|
                    self.extendValues.ratioValues.normalHitRate
                        - enemy.extendValues.ratioValues.avoidRate
                        + hitRateUp
    in
    if isAvoid then
        ( enemy, True )

    else
        ( normalAttackDemage enemy self env, False )


attackRec : Self -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> BaseData -> ( Data, Bool, Bool )
attackRec self env allEnemy position basedata =
    let
        targetEnemy =
            Maybe.withDefault { defaultEnemy | position = 0 } <|
                List.head <|
                    List.filter (\x -> x.position == position) allEnemy

        ( newEnemy, isAvoid ) =
            getHurt self env targetEnemy

        newBuff =
            if basedata.state == EnemyAttack then
                getNewBuff newEnemy.buff

            else
                newEnemy.buff

        newData =
            List.filter
                (\x -> x.hp /= 0)
            <|
                List.map
                    (\x ->
                        if x.position == position then
                            { newEnemy | buff = newBuff }

                        else
                            x
                    )
                    allEnemy

        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        front =
            List.any (\p -> p <= 3) basedata.selfNum

        effective =
            if front && self.position > 3 then
                False

            else
                True

        criticalUp =
            List.sum <|
                List.map
                    (\( b, _ ) ->
                        case b of
                            CriticalRateUp value ->
                                value

                            _ ->
                                0
                    )
                    self.buff

        isCounter =
            if newEnemy.hp /= 0 && basedata.state /= PlayerAttack False && self.name /= "Bruce" && effective then
                checkRate time (newEnemy.extendValues.ratioValues.counterRate + criticalUp)

            else
                False
    in
    ( newData, isCounter, isAvoid )


findMin : Data -> Int
findMin data =
    data
        |> List.map (\x -> x.position)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100


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
    List.map (\t -> getEffect self skill env t basedata) newTargets


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
