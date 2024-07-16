module Scenes.Game.Components.Enemy.GenRatio exposing (..)

import Lib.UserData exposing (UserData)
import Messenger.Base
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Self.GetBasicValue exposing (genRandomNum)
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.SceneBase exposing (Element(..), SceneCommonData)


genActionPoints : Enemy -> Messenger.Base.Env SceneCommonData UserData -> Float
genActionPoints enemy env =
    -- let
    --     upperBound =
    --         char.attributes.agility
    -- in
    -- genRandomNum 1 upperBound env
    enemy.attributes.agility


genAvoidRate : Enemy -> Float
genAvoidRate enemy =
    enemy.attributes.agility / 100


genNormalHitRate : Enemy -> Self -> Float
genNormalHitRate enemy char =
    60 + enemy.attributes.agility + enemy.attributes.spirit - char.attributes.agility


genMagicalHitRate : Enemy -> Self -> Float
genMagicalHitRate enemy char =
    80 + enemy.attributes.spirit - char.attributes.agility


genCriticalHitRate : Enemy -> Float
genCriticalHitRate enemy =
    10


genCounterRate : Enemy -> Float
genCounterRate enemy =
    (enemy.attributes.agility + enemy.attributes.spirit) / 4


getSpecificResistance : Enemy -> Element -> Float
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


getSpecificNormalAttack : Enemy -> Self -> Bool -> Float
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


initSelf : Enemy -> Enemy
initSelf enemy =
    enemy


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
