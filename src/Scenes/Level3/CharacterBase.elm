module Scenes.Level3.CharacterBase exposing
    ( Character
    , bithif
    , bruce
    , bulingze
    , cavalry
    , convert
    , genChar
    , genSelf
    , oneChar
    , wenderd
    )

import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.GenAttributes exposing (Attribute, EleResistance, ExtendValue, genExtendValues, genHp, genMp)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (airBlade, arcaneBeam, blessingOfAir, blindness, chainLightning, compounding, doubleStrike, fireBall, frostArrow, frostImpact, gale, iceRing, inspirationOfFire, lightningSpell, magicTransformation, scatterShot, whirlwindAccelaration)
import SceneProtos.Game.Components.Special.Library2 exposing (magicWater, poison, restorationPotion)


{-| Character data
-}
type alias Character =
    { name : String
    , x : Int
    , y : Float
    , position : Int
    , hp : Int
    , mp : Int
    , attributes : Attribute
    , extendValues : ExtendValue
    , skills : List Skill
    }


{-| Generate a character
-}
oneChar : Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> String -> List Skill -> Self
oneChar time pos str dex con int water fire air earth name skills =
    let
        baseAttributes =
            { strength = str
            , dexterity = dex
            , constitution = con
            , intelligence = int
            }

        baseEleResistance =
            { waterResistance = water
            , fireResistance = fire
            , airResistance = air
            , earthResistance = earth
            }
    in
    genSelf pos
        time
        name
        baseAttributes
        baseEleResistance
        skills


{-| Wendard base attributes
-}
wenderd : Int -> Self
wenderd time =
    oneChar time 1 56 34 42 28 10 10 20 10 "Wenderd" <|
        [ arcaneBeam, airBlade, doubleStrike, { poison | cost = 1 } ]


{-| Bruce base attributes
-}
bruce : Int -> Self
bruce time =
    oneChar time 2 35 55 30 40 20 10 10 10 "Bruce" <|
        [ arcaneBeam, scatterShot, frostArrow, frostImpact, iceRing, { poison | cost = 1 }, { magicWater | cost = 1 }, { poison | cost = 1 } ]


{-| Bulingze base attributes
-}
bulingze : Int -> Self
bulingze time =
    oneChar time 4 28 35 32 65 10 20 10 10 "Bulingze" <|
        [ arcaneBeam, fireBall, inspirationOfFire, blindness, { poison | cost = 1 }, { magicWater | cost = 1 } ]


{-| Bithif base attributes
-}
bithif : Int -> Self
bithif time =
    oneChar time 5 30 42 36 50 10 10 20 10 "Bithif" <|
        [ arcaneBeam, compounding, magicTransformation, whirlwindAccelaration, gale, { magicWater | cost = 1 }, { poison | cost = 1 }, { restorationPotion | cost = 1 } ]


{-| Cavalry base attributes
-}
cavalry : Int -> Self
cavalry time =
    oneChar time 6 40 30 34 56 10 10 20 10 "Cavalry" <|
        [ arcaneBeam, airBlade, lightningSpell, chainLightning, blessingOfAir, { restorationPotion | cost = 1 } ]


{-| Generate a character
-}
genChar : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Bool -> Character
genChar position time name baseAttributes baseEleResistance skills flag =
    { name = name
    , x =
        if flag then
            if position <= 3 then
                1100

            else
                1220

        else if position <= 9 then
            230

        else
            100
    , y =
        if flag then
            toFloat (160 + 130 * (position - (position - 1) // 3 * 3 - 1))

        else
            toFloat (160 + 130 * (position - (position - 7) // 3 * 3 - 7))
    , position = position
    , hp = genHp baseAttributes
    , mp = genMp baseAttributes
    , attributes = baseAttributes
    , extendValues =
        genExtendValues
            baseAttributes
            (time + position)
            baseEleResistance.waterResistance
            baseEleResistance.fireResistance
            baseEleResistance.airResistance
            baseEleResistance.earthResistance
    , skills = skills
    }


{-| Convert a character to self and enemy
-}
convert : Character -> ( Self, Enemy )
convert char =
    ( { defaultSelf
        | name = char.name
        , x = toFloat char.x
        , y = char.y
        , position = char.position
        , hp = char.hp
        , mp = char.mp
        , attributes = char.attributes
        , extendValues = char.extendValues
        , skills = char.skills
      }
    , { defaultEnemy
        | name = char.name
        , x = toFloat char.x
        , y = char.y
        , position = char.position
        , hp = char.hp
        , mp = char.mp
        , attributes = char.attributes
        , extendValues = char.extendValues
        , skills = char.skills
      }
    )


{-| Generate a self
-}
genSelf : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Self
genSelf position time name baseAttributes baseEleResistance skills =
    let
        ( self, _ ) =
            convert
                (genChar position time name baseAttributes baseEleResistance skills True)
    in
    self
