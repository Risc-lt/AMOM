module SceneProtos.Game.Components.Special.SpeSkill exposing
    ( getNewBuff
    , scatterShot, frostArrow, airBlade, doubleStrike, compounding, magicTransformation, gale, fieryThrust, arcaneBeam, frostImpact, iceRing, cure, fireBall, inspirationOfFire, blindness, whirlwindAccelaration
    )

{-| #Library module

This module contains the special skills for the game.

@docs getNewBuff
@docs scatterShot, frostArrow, airBlade, doubleStrike, compounding, magicTransformation, gale, fieryThrust, arcaneBeam, frostImpact, iceRing, cure, fireBall, inspirationOfFire, blindness, whirlwindAccelaration

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
    , effect = { defaultEffect | mp = 16 }
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


{-| Skill: Arcane Beam
-}
arcaneBeam : Skill
arcaneBeam =
    { kind = Magic
    , name = "Arcane Beam"
    , effect = { defaultEffect | hp = 20 }
    , buff = []
    , range = One
    , element = None
    , cost = 5
    , lasting = 0
    , content = 
        [ "Attack one enemy."
        , "Element depends on the user."
        , "20 damage"
        ]
    }


{-| Skill: Inspiration of Fire
-}
frostImpact : Skill
frostImpact =
    { kind = Magic
    , name = "Frost Impact"
    , effect = { defaultEffect | hp = 28 }
    , buff = [ SpeedDown 5 ]
    , range = One
    , element = Water
    , cost = 11
    , lasting = 1
    , content = 
        [ "Attack one enemy."
        , "water"
        , "28 damage"
        , "'Retard' for one turn"
        ]
    }


{-| Skill: Ice Ring
-}
iceRing : Skill
iceRing =
    { kind = Magic
    , name = "Ice Ring"
    , effect = defaultEffect
    , buff = [ NoAction ]
    , range = OneTheOther { defaultEffect | hp = 22 }
    , element = Water
    , cost = 16
    , lasting = 1
    , content = 
        [ "Use on one enemy."
        , "water"
        , "'Seal' for one turn"
        , "Attack the other enemies in the same region."
        , "22 damage"
        ]
    }


{-| Skill: Cure
-}
cure : Skill
cure =
    { kind = Magic
    , name = "Cure"
    , effect = { defaultEffect | hp = -50 }
    , buff = []
    , range = Ally
    , element = Water
    , cost = 12
    , lasting = 0
    , content = []
    }


{-| Skill: Fire Ball
-}
fireBall : Skill
fireBall =
    { kind = Magic
    , name = "Fire Ball"
    , effect = { defaultEffect | hp = 42 }
    , buff = []
    , range = Region
    , element = Fire
    , cost = 13
    , lasting = 0
    , content = 
        [ "Attack all enemies in a region."
        , "fire"
        , "42 damage"
        ]
    }


{-| Skill: Inspiration of Fire
-}
inspirationOfFire : Skill
inspirationOfFire =
    { kind = Magic
    , name = "Inspiration of Fire"
    , effect = defaultEffect
    , buff = [ AttackUp 70 ]
    , range = Ally
    , element = Fire
    , cost = 9
    , lasting = 2
    , content = 
        [ "Use on an ally."
        , "fire"
        , "'Brave' for two turns"
        ]
    }


{-| Skill: Blindness
-}
blindness : Skill
blindness =
    { kind = Magic
    , name = "Blindness"
    , effect = defaultEffect
    , buff = [ NoAction ]
    , range = One
    , element = Fire
    , cost = 18
    , lasting = 2
    , content = 
        [ "Use on one enemy."
        , "fire"
        , "'Seal' for two turns"
        ]
    }


{-| Skill: Whirlwind Acceleration
-}
whirlwindAccelaration : Skill
whirlwindAccelaration =
    { kind = Magic
    , name = "Whirlwind Acceleration"
    , effect = defaultEffect
    , buff = [ SpeedUp 10 ]
    , range = Ally
    , element = Air
    , cost = 3
    , lasting = 2
    , content = 
        [ "Use on an ally."
        , "air"
        , "'Acceleration' for one turn"
        ]
    }
