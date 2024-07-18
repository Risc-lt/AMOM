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


getSpecificMagicalAttack : Self -> Enemy -> Int
getSpecificMagicalAttack self enemy =
    floor (1 + toFloat self.attributes.intelligence * 0.025)


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
            List.filter
                (\x -> x.hp /= 0)
            <|
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
