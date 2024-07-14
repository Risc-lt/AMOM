module Scenes.Game.Components.Self.GetBasicValue exposing (..)


import Random
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.SceneBase exposing (Element(..))


genActionPoints : Self -> Float
genActionPoints char =
   let
        seed = Basics.round char.attributes.agility

        (value, newSeed) = 
            Random.step (Random.int 1 seed) 
                <| Random.initialSeed seed
    in
    Basics.toFloat value 


genAvoidRate : Self -> Float
genAvoidRate char =
    char.attributes.agility


genNormalHitRate : Self -> Enemy -> Float
genNormalHitRate char enemy =
    60 + char.attributes.agility  + char.attributes.spirit - enemy.attributes.agility
    

genMagicalHitRate : Self -> Enemy -> Float
genMagicalHitRate char enemy = 
    80 + char.attributes.spirit - enemy.attributes.agility


genCriticalHitRate : Self -> Float
genCriticalHitRate char = 
    10


genCounterRate : Self -> Float
genCounterRate char = 
    ( char.attributes.agility + char.attributes.spirit ) / 4


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

getSpecificNormalAttack : Self -> Enemy -> Float
getSpecificNormalAttack char enemy = 
    let
        criticalHitRate = 
            if genMagicalHitRate char enemy > 10 then
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
    { char | 
        hpMax = char.attributes.stamina * 4
    ,   mpMax = char.attributes.spirit
    }