module Scenes.Game.Components.Self.AttackRec exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ActionMsg(..), ComponentTarget, Gamestate(..))
import Scenes.Game.Components.GenRandom exposing (..)
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.SceneBase exposing (SceneCommonData)
import Time
import Scenes.Game.Components.Enemy.UpdateOne exposing (attackMsg)


type alias Data =
    List Self


checkHealth : Self -> Self
checkHealth self =
    if self.hp < 0 then
        { self | hp = 0 }

    else
        self


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


normalAttackDemage : Self -> Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self
normalAttackDemage self enemy env =
    let
        time =
            Time.posixToMillis env.globalData.currentTimeStamp

        isCritical =
            checkRate time self.extendValues.ratioValues.criticalHitRate

        damage =
            getSpecificNormalAttack self enemy isCritical
    in
    checkHealth <|
        { self | hp = self.hp - damage, energy = self.energy + 30 }


getSpecificNormalAttack : Self -> Enemy -> Bool -> Int
getSpecificNormalAttack self enemy isCritical =
    let
        criticalHitRate =
            if isCritical then
                1.5

            else
                1
    in
    floor (toFloat (20 * self.attributes.strength // enemy.attributes.constitution) * criticalHitRate)


getSpecificMagicalAttack : Self -> Enemy -> Int
getSpecificMagicalAttack self enemy =
    floor (1 + toFloat self.attributes.intelligence * 0.025)


getHurt : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Self -> Self
getHurt enemy env self =
    let
        time = 
            Time.posixToMillis env.globalData.currentTimeStamp

        isAvoid =
            checkRate time self.extendValues.ratioValues.avoidRate
    in
    if isAvoid then
        self

    else
        normalAttackDemage self enemy env


attackRec : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Data -> Int -> ( Data, Bool, Self )
attackRec enemy env allSelf position =
    let
        targetSelf =
            Maybe.withDefault { defaultSelf | position = 0 } <|
                List.head <|
                    List.filter (\x -> x.position == position) allSelf

        newSelf =
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

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        time = 
            Time.posixToMillis env.globalData.currentTimeStamp

        isCounter =
            if List.length remainNum == List.length allSelf then
                checkRate time targetSelf.extendValues.ratioValues.counterRate

            else
                False
    in
    ( newData, isCounter, newSelf )


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
        ( newData, isCounter, newSelf ) =
            attackRec enemy env data position

        remainNum =
            List.map (\x -> x.position) <|
                List.filter (\x -> x.hp /= 0) <|
                    newData

        counterMsg =
            if isCounter then
                []

            else
                [ Other ("Enemy", Action (PlayerNormal newSelf enemy.position True)) ]

        dieMsg =
            if remainNum == basedata.selfNum then
                []

            else
                [ Other ( "Enemy", CharDie remainNum ) ]
    in
    ( ( newData, { basedata | selfNum = remainNum } ), counterMsg ++ dieMsg, env )
