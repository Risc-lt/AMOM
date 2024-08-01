module SceneProtos.Game.Components.Enemy.AttackRec exposing
    ( Data
    , attackRec
    , checkStatus
    , findMin
    , getHurt
    , getSpecificNormalAttack
    , normalAttackDemage
    )

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
import SceneProtos.Game.Components.Special.SpeSkill exposing (getNewBuff)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Time


{-| The data used to initialize the scene
-}
type alias Data =
    List Enemy


{-| The conditions that trigger the story
-}
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


{-| The initial data for the StroryTrigger component
-}
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


{-| The initial data for the StroryTrigger component
-}
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
            * toFloat self.attributes.strength
            / toFloat enemy.attributes.constitution
            * criticalHitRate
            * toFloat (100 + attackUp - defenceUp)
            / 100
        )


{-| The initial data for the StroryTrigger component
-}
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


{-| The initial data for the StroryTrigger component
-}
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


{-| The initial data for the StroryTrigger component
-}
findMin : Data -> Int
findMin data =
    data
        |> List.map (\x -> x.position)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100
