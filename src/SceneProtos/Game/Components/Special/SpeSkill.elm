module SceneProtos.Game.Components.Special.SpeSkill exposing
    ( getNewBuff
    , scatterShot, frostArrow, airBlade, doubleStrike, compounding, magicTransformation, gale, fieryThrust
    )

{-| #SpeSkill module

This module contains the special skills for the game.

@docs getNewBuff
@docs scatterShot, frostArrow, airBlade, doubleStrike, compounding, magicTransformation, gale, fieryThrust

-}

import SceneProtos.Game.Components.Special.Init exposing (..)


{-| Get new buff
-}
getNewBuff : List ( Buff, Int ) -> List ( Buff, Int )
getNewBuff buff =
    List.filter
        (\( _, l ) ->
            l /= 0
        )
    <|
        List.map
            (\( b, l ) ->
                ( b, l - 1 )
            )
            buff


{-| Skill: Scatter Shot
-}
scatterShot : Skill
scatterShot =
    { kind = SpecialSkill
    , name = "Scatter Shot"
    , effect = { defaultEffect | hp = 40 }
    , buff = []
    , range = AllFront
    , element = None
    , cost = 100
    , lasting = 0
    , content =
        [ "Attack all front enemies."
        , "no elelment"
        , "40 damage"
        ]
    }


{-| Skill: Frost Arrow
-}
frostArrow : Skill
frostArrow =
    { kind = SpecialSkill
    , name = "Frost Arrow"
    , effect = { defaultEffect | hp = 30 }
    , buff = [ NoAction ]
    , range = One
    , element = Water
    , cost = 100
    , lasting = 1
    , content =
        [ "Attack one enemy."
        , "water"
        , "30 damage"
        , "'Seal' for one turn"
        ]
    }


{-| Skill: Air Blade
-}
airBlade : Skill
airBlade =
    { kind = SpecialSkill
    , name = "Air Blade"
    , effect = { defaultEffect | hp = 80 }
    , buff = []
    , range = One
    , element = None
    , cost = 100
    , lasting = 0
    , content =
        [ "Attack one enemy."
        , "no element"
        , "80 damage"
        ]
    }


{-| Skill: Double Strike
-}
doubleStrike : Skill
doubleStrike =
    { kind = SpecialSkill
    , name = "Double Strike"
    , effect = defaultEffect
    , buff = [ ExtraAttack ]
    , range = Oneself
    , element = None
    , cost = 100
    , lasting = 2
    , content =
        [ "Use on oneself."
        , "no element"
        , "'Bloodthirsty' for two turns"
        ]
    }


{-| Skill: Compounding
-}
compounding : Skill
compounding =
    { kind = SpecialSkill
    , name = "Compounding"
    , effect = defaultEffect
    , buff = []
    , range = Oneself
    , element = None
    , cost = 100
    , lasting = 0
    , content =
        [ "Compound a bottle of potion."
        , "no element"
        ]
    }


{-| Skill: Magic Transformation
-}
magicTransformation : Skill
magicTransformation =
    { kind = SpecialSkill
    , name = "Magic Transformation"
    , effect = { defaultEffect | mp = -16 }
    , buff = []
    , range = Ally
    , element = None
    , cost = 100
    , lasting = 0
    , content =
        [ "Use on an ally."
        , "no element"
        , "16 magic points restoration"
        ]
    }


{-| Skill: Gale
-}
gale : Skill
gale =
    { kind = SpecialSkill
    , name = "Gale"
    , effect = defaultEffect
    , buff = [ SpeedDown 10 ]
    , range = AllFront
    , element = Air
    , cost = 100
    , lasting = 2
    , content =
        [ "Use on all front enemies."
        , "air"
        , "'Retard' for two turns"
        ]
    }


{-| Skill: Fiery Thrust
-}
fieryThrust : Skill
fieryThrust =
    { kind = SpecialSkill
    , name = "Fiery Thrust"
    , effect = defaultEffect
    , buff = [ LoseHp ]
    , range = PenetrateOne
    , element = Fire
    , cost = 200
    , lasting = 2
    , content = []
    }
