module SceneProtos.Game.Components.Self.AttackRec exposing (Data, checkBuff, checkStatus, findMin, getHurt, getSpecificNormalAttack, normalAttackDemage, attackRec)

{-|


# Self AttackRec module

This module is responsible for handling the attack record of the self component.

@docs Data, checkBuff, checkStatus, findMin, getHurt, getSpecificNormalAttack, normalAttackDemage, attackRec

-}

import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), Gamestate(..), StatusMsg(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.GenRandom exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Element(..), Range(..), SpecialType(..))
import SceneProtos.Game.Components.Special.SpeSkill exposing (getNewBuff)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time


{-| The initial data for the StroryTrigger component
-}
type alias Data =
    List Self


{-| The initial data for the StroryTrigger component
-}
checkStatus : Self -> Self
checkStatus self =
    let
        lowHpCheck =
            if self.hp < 0 then
                { self | hp = 0 }

            else
                self

        highHpCheck =
            if self.hp > self.extendValues.basicStatus.maxHp then
                { lowHpCheck | hp = self.extendValues.basicStatus.maxHp }

            else
                lowHpCheck

        mpCheck =
            if self.mp > self.extendValues.basicStatus.maxMp then
                { highHpCheck | mp = self.extendValues.basicStatus.maxMp }

            else
                highHpCheck

        energyCheck =
            if self.energy > 300 then
                { mpCheck | energy = 300 }

            else
                mpCheck
    in
    energyCheck


{-| The initial data for the StroryTrigger component
-}
checkBuff : Self -> Self
checkBuff data =
    let
        newData =
            if List.any (\( b, _ ) -> b == LoseHp) data.buff then
                checkStatus <| { data | hp = data.hp - 10 }

            else
                data
    in
    { newData | buff = getNewBuff data.buff }


{-| The initial data for the StroryTrigger component
-}
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
    checkStatus <|
        { self | hp = self.hp - damage, energy = newEnergy }


{-| The initial data for the StroryTrigger component
-}
getSpecificNormalAttack : Self -> Enemy -> Bool -> Int
getSpecificNormalAttack self enemy isCritical =
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
                    enemy.buff

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
                    self.buff
    in
    floor <|
        (20
            * toFloat enemy.attributes.strength
            / toFloat self.attributes.constitution
            * criticalHitRate
            * toFloat (100 + attackUp - defenceUp)
            / 100
        )


{-| The initial data for the StroryTrigger component
-}
getHurt : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self -> ( Self, Bool )
getHurt enemy env self =
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
                    enemy.buff

        isAvoid =
            not <|
                checkRate time <|
                    enemy.extendValues.ratioValues.normalHitRate
                        - self.extendValues.ratioValues.avoidRate
                        + hitRateUp
    in
    if isAvoid then
        ( self, True )

    else
        ( normalAttackDemage self enemy env, False )


{-| The initial data for the StroryTrigger component
-}
attackRec : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> BaseData -> ( Data, Bool, Bool )
attackRec enemy env allSelf position basedata =
    let
        targetSelf =
            Maybe.withDefault { defaultSelf | position = 0 } <|
                List.head <|
                    List.filter (\x -> x.position == position) allSelf

        ( newSelf, isAvoid ) =
            getHurt enemy env targetSelf

        newBuff =
            if basedata.state == EnemyAttack then
                getNewBuff newSelf.buff

            else
                newSelf.buff

        newData =
            List.map
                (\x ->
                    if x.position == position then
                        { newSelf | buff = newBuff }

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
                    enemy.buff

        isCounter =
            if newSelf.hp /= 0 && basedata.state /= EnemyAttack && effective then
                checkRate time (newSelf.extendValues.ratioValues.counterRate + criticalUp)

            else
                False
    in
    ( newData, isCounter, isAvoid )


{-| The initial data for the StroryTrigger component
-}
findMin : Data -> Int
findMin data =
    data
        |> List.map (\x -> x.position)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100
