module Scenes.Game.Components.Enemy.AttackRec exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.GenRandom exposing (..)
import Scenes.Game.Components.Self.Init exposing (Self, State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)
import Time


type alias Data =
    List Enemy


checkHealth : Enemy -> Enemy
checkHealth enemy =
    if enemy.hp < 0 then
        { enemy | hp = 0 }

    else
        enemy


normalAttackDemage : Enemy -> Self -> Messenger.Base.Env SceneCommonData UserData -> Enemy
normalAttackDemage enemy self env =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isCritical =
            checkRate time enemy.extendValues.ratioValues.criticalHitRate

        damage =
            getSpecificNormalAttack enemy self isCritical
    in
    checkHealth <|
        { enemy | hp = enemy.hp - damage, energy = enemy.energy + 30 }


getSpecificNormalAttack : Enemy -> Self -> Bool -> Int
getSpecificNormalAttack enemy self isCritical =
    let
        criticalHitRate =
            if isCritical then
                1.5

            else
                1
    in
    floor (20 * toFloat enemy.attributes.strength / toFloat self.attributes.constitution * criticalHitRate)


getSpecificMagicalAttack : Enemy -> Self -> Int
getSpecificMagicalAttack enemy self =
    floor (1 + toFloat enemy.attributes.intelligence * 0.025)


getHurt : Self -> Messenger.Base.Env SceneCommonData UserData -> Enemy -> ( Enemy, Bool )
getHurt self env enemy =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isAvoid =
            not <|
                checkRate time <|
                    self.extendValues.ratioValues.normalHitRate
                        - enemy.extendValues.ratioValues.avoidRate
    in
    if isAvoid then
        ( enemy, True )

    else
        ( normalAttackDemage enemy self env, False )


attackRec : Bool -> Self -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> ( Data, ( Bool, Bool ), Enemy )
attackRec selfCounter self env allEnemy position =
    let
        targetEnemy =
            Maybe.withDefault { defaultEnemy | position = 0 } <|
                List.head <|
                    List.filter (\x -> x.position == position) allEnemy

        ( newEnemy, isAvoid ) =
            getHurt self env targetEnemy

        newData =
            List.filter
                (\x -> x.hp /= 0)
            <|
                List.map
                    (\x ->
                        if x.position == position then
                            newEnemy

                        else
                            x
                    )
                    allEnemy

        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isCounter =
            if newEnemy.hp /= 0 && not selfCounter then
                checkRate time targetEnemy.extendValues.ratioValues.counterRate

            else
                False
    in
    ( newData, ( isCounter, isAvoid ), newEnemy )


findMin : Data -> Int
findMin data =
    data
        |> List.map (\x -> x.position)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100


handleAttack : Bool -> Self -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack selfCounter self position env msg data basedata =
    let
        ( newData, ( isCounter, isAvoid ), newEnemy ) =
            attackRec selfCounter self env data position

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        counterMsg =
            if isCounter then
                [ Other ( "Self", Action (EnemyNormal newEnemy self.position True) ) ]

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
    ( ( newData, { basedata | enemyNum = remainNum } ), counterMsg ++ avoidMsg ++ dieMsg, env )
