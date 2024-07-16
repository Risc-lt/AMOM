module Scenes.Game.Components.Self.GetBasicValue exposing (..)

import Lib.UserData exposing (UserData)
import Messenger.Base
import Random
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.SceneBase exposing (Element(..), SceneCommonData)
import Time


genRandomNum : Float -> Float -> Messenger.Base.Env SceneCommonData UserData -> Float
genRandomNum lowerBound upperBound env =
    let
        ( value, newSeed ) =
            Random.step (Random.float lowerBound upperBound) <|
                Random.initialSeed <|
                    Time.posixToMillis env.globalData.currentTimeStamp
    in
    value


genActionPoints : Self -> Messenger.Base.Env SceneCommonData UserData -> Float
genActionPoints char env =
    -- let
    --     upperBound =
    --         char.attributes.agility
    -- in
    -- genRandomNum 1 upperBound env
    char.attributes.agility


genAvoidRate : Self -> Float
genAvoidRate char =
    char.attributes.agility


genNormalHitRate : Self -> Enemy -> Float
genNormalHitRate char enemy =
    60 + char.attributes.agility + char.attributes.spirit - enemy.attributes.agility


genMagicalHitRate : Self -> Enemy -> Float
genMagicalHitRate char enemy =
    80 + char.attributes.spirit - enemy.attributes.agility


genCriticalHitRate : Self -> Float
genCriticalHitRate char =
    10


genCounterRate : Self -> Float
genCounterRate char =
    (char.attributes.agility + char.attributes.spirit) / 4


getSpecificResistance : Self -> Element -> Float
getSpecificResistance char elm =
    let
        baseResistance =
            case elm of
                Fire ->
                    char.attributes.fireResistance

                Water ->
                    char.attributes.waterResistance

                Wind ->
                    char.attributes.windResistance

                Earth ->
                    char.attributes.earthResistance
    in
    baseResistance + char.attributes.spirit


getSpecificNormalAttack : Self -> Enemy -> Bool -> Float
getSpecificNormalAttack char enemy isCritical =
    let
        criticalHitRate =
            if isCritical then
                1.5

            else
                1
    in
    20 * char.attributes.strength / enemy.attributes.stamina * criticalHitRate


getSpecificMagicalAttack : Self -> Enemy -> Float
getSpecificMagicalAttack char enemy =
    1 + char.attributes.spirit * 0.025


initSelf : Self -> Self
initSelf char =
    { char
        | hpMax = char.attributes.stamina * 4
        , mpMax = char.attributes.spirit
        , mp = char.attributes.spirit
        , hp = char.attributes.stamina * 4
    }


checkRate : Messenger.Base.Env SceneCommonData UserData -> Float -> Bool
checkRate env rate =
    let
        randomNum =
            genRandomNum 0 1 env
    in
    if randomNum < rate then
        True

    else
        False
