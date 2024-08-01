module SceneProtos.Game.Components.Special.Magic exposing (arcaneBeam, frostImpact, iceRing, cure, fireBall, inspirationOfFire, blindness, whirlwindAccelaration, blessingOfAir, chainLightning, lightningSpell, mudSwamp, stoneSkin)

{-|


# Magic module

This module contains the magics for the game.

@docs arcaneBeam, frostImpact, iceRing, cure, fireBall, inspirationOfFire, blindness, whirlwindAccelaration, blessingOfAir, chainLightning, lightningSpell, mudSwamp, stoneSkin

-}

import SceneProtos.Game.Components.Special.Init exposing (..)


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


{-| Skill: Mud Swamp
-}
mudSwamp : Skill
mudSwamp =
    { kind = Magic
    , name = "Mud Swamp"
    , effect = defaultEffect
    , buff = [ SpeedDown 5 ]
    , range = AllEnemy
    , element = Earth
    , cost = 10
    , lasting = 3
    , content = []
    }


{-| Skill: Stone Skin
-}
stoneSkin : Skill
stoneSkin =
    { kind = Magic
    , name = "Stone Skin"
    , effect = defaultEffect
    , buff = [ DefenceUp 60 ]
    , range = Ally
    , element = Earth
    , cost = 7
    , lasting = 3
    , content = []
    }


{-| Skill: Lightning Spell
-}
lightningSpell : Skill
lightningSpell =
    { kind = Magic
    , name = "Lightning Spell"
    , effect = { defaultEffect | hp = 32 }
    , buff = []
    , range = One
    , element = Air
    , cost = 11
    , lasting = 0
    , content =
        [ "Attack one enemy."
        , "air"
        , "32 damage"
        ]
    }


{-| Skill: Chain Lighting
-}
chainLightning : Skill
chainLightning =
    { kind = Magic
    , name = "Chain Lighting"
    , effect = { defaultEffect | hp = 29 }
    , buff = []
    , range = Chain
    , element = Air
    , cost = 16
    , lasting = 0
    , content =
        [ "Attack one enemy and the nearby enemies."
        , "air"
        , "29 damage"
        ]
    }


{-| Skill: Blessing of Air
-}
blessingOfAir : Skill
blessingOfAir =
    { kind = Magic
    , name = "Blessing of Air"
    , effect = defaultEffect
    , buff = [ HitRateUp 10, CriticalRateUp 60 ]
    , range = Ally
    , element = Air
    , cost = 8
    , lasting = 2
    , content =
        [ "Use on an ally."
        , "air"
        , "'Concentration' for one turn"
        , "'Precision' for one turn"
        ]
    }
