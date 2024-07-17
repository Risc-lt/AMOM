module Scenes.Game.Components.Enemy.AttackRec exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.GenRandom exposing (..)
import Scenes.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import Scenes.Game.Components.Self.Init exposing (Self, State(..))
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Enemy


checkHealth : Enemy -> Enemy
checkHealth enemy =
    if enemy.hp < 0 then
        { enemy | hp = 0 }

    else
        enemy


checkRate : Int -> Int -> Bool
checkRate time rate =
    let
        randomNum =
            genRandomNum 0 1 time
    in
    if randomNum < rate then
        True

    else
        False


normalAttackDemage : Enemy -> Self -> Messenger.Base.Env SceneCommonData UserData -> Enemy
normalAttackDemage enemy char env =
    let
        isCritical =
            checkRate env <|
                genCriticalHitRate enemy

        demage =
            getSpecificNormalAttack enemy char isCritical
    in
    checkHealth <|
        { enemy | hp = enemy.hp - demage }


getSpecificNormalAttack : Enemy -> Self -> Bool -> Int
getSpecificNormalAttack enemy char isCritical =
    let
        criticalHitRate =
            if isCritical then
                1.5

            else
                1
    in
    20 * enemy.attributes.strength / char.attributes.stamina * criticalHitRate


getSpecificMagicalAttack : Enemy -> Self -> Float
getSpecificMagicalAttack enemy char =
    1 + enemy.attributes.spirit * 0.025


getHurt : AttackType -> Self -> Messenger.Base.Env SceneCommonData UserData -> Enemy -> Enemy
getHurt attackType char env enemy =
    let
        isAvoid =
            checkRate env <|
                genAvoidRate enemy
    in
    if isAvoid then
        enemy

    else
        case attackType of
            NormalAttack ->
                normalAttackDemage enemy char env

            SpecialSkill ->
                checkHealth <|
                    { enemy | hp = char.hp - 50 }

            Magic ->
                checkHealth <|
                    { enemy | hp = char.hp - 50 }


attackRec : AttackType -> Self -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> Data
attackRec attackType char env allEnemy position =
    let
        targetEnemy =
            Maybe.withDefault { defaultEnemy | position = 0 } <|
                List.head <|
                    List.filter (\x -> x.position == position) allEnemy

        newEnemy =
            getHurt attackType char env targetEnemy

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
    in
    newData


findMin : Data -> Int
findMin data =
    data
        |> List.map (\x -> x.position)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100


handleAttack : AttackType -> Self -> Int -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
handleAttack attackType char position env msg data basedata =
    let
        newData =
            attackRec attackType char env data position

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        newMsg =
            if remainNum == basedata.enemyNum then
                []

            else
                [ Other ( "Self", EnemyDie remainNum ) ]
    in
    ( ( newData, { basedata | enemyNum = remainNum } ), newMsg, env )
