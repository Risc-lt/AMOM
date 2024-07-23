module Scenes.Game.Components.Self.AttackRec exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), StatusMsg(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.GenRandom exposing (..)
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.SceneBase exposing (SceneCommonData)
import Time
import Scenes.Game.Components.Special.Init exposing (Skill)
import Scenes.Game.Components.Special.Init exposing (Element(..))
import Scenes.Game.Components.Special.Init exposing (Range(..))
import Scenes.Game.Components.Special.Init exposing (SpecialType(..))


type alias Data =
    List Self


checkHealth : Self -> Self
checkHealth self =
    if self.hp < 0 then
        { self | hp = 0 }

    else
        self


normalAttackDemage : Self -> Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self
normalAttackDemage self enemy env =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isCritical =
            checkRate time self.extendValues.ratioValues.criticalHitRate

        damage =
            getSpecificNormalAttack self enemy isCritical

        newEnergy =
            if self.energy + 30 > 300 then
                300

            else
                self.energy + 30
    in
    checkHealth <|
        { self | hp = self.hp - damage, energy = newEnergy }


getSpecificNormalAttack : Self -> Enemy -> Bool -> Int
getSpecificNormalAttack self enemy isCritical =
    let
        criticalHitRate =
            if isCritical then
                1.5

            else
                1
    in
    floor (20 * toFloat self.attributes.strength / toFloat enemy.attributes.constitution * criticalHitRate)


getHurt : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self -> ( Self, Bool )
getHurt enemy env self =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isAvoid =
            not <|
                checkRate time <|
                    enemy.extendValues.ratioValues.normalHitRate
                        - self.extendValues.ratioValues.avoidRate
    in
    if isAvoid then
        ( self, True )

    else
        ( normalAttackDemage self enemy env, False )


attackRec : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> BaseData -> ( Data, Bool, Bool )
attackRec enemy env allSelf position basedata =
    let
        targetSelf =
            Maybe.withDefault { defaultSelf | position = 0 } <|
                List.head <|
                    List.filter (\x -> x.position == position) allSelf

        ( newSelf, isAvoid ) =
            getHurt enemy env targetSelf

        newData =
            List.map
                (\x ->
                    if x.position == position then
                        newSelf

                    else
                        x
                )
                allSelf

        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        melee =
            newSelf.name /= "Bruce"

        front =
            List.any (\p -> p <= 9) basedata.enemyNum

        effective =
            if melee && front && enemy.position > 9 then
                False

            else
                True

        isCounter =
            if newSelf.hp /= 0 && basedata.state /= EnemyAttack && effective then
                checkRate time newSelf.extendValues.ratioValues.counterRate

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
    ( ( newData, { basedata | selfNum = remainNum, curSelf = position, curEnemy = enemy.position } )
    , counterMsg ++ avoidMsg ++ dieMsg
    , env
    )

getSpecificMagicalAttack : Self -> Enemy -> Skill -> Int
getSpecificMagicalAttack self enemy skill =
    let
        element =
            if skill.name == "Arcane Beam" then
                case enemy.name of
                    "Kunzite" ->
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


getEffect : Enemy -> Skill -> Messenger.Base.Env SceneCommonData UserData -> Self -> BaseData -> Self
getEffect enemy skill env target basedata =
    let
        hpChange =
            if skill.kind == Magic then
                getSpecificMagicalAttack target enemy skill

            else
                skill.effect.hp
    in
    checkHealth { target | hp = target.hp - hpChange }


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


handleSkill : Enemy -> Skill -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleSkill enemy skill position env msg data basedata =
    let
        newSelfs =
            skillRec enemy skill env data position basedata

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
    , dieMsg ++ [ Other ( "Interface", SwitchTurn 0 ) ]
    , env
    )
