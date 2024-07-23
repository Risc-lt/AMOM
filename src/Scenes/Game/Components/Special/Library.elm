module Scenes.Game.Components.Special.Library exposing (..)

{-| Skill library

@docs scatterShot
@docs airBlade
@docs compounding
@docs arcaneBeam
@docs fireBall
@docs restorationPotion
@docs magicWater
@docs poison

-}

import Scenes.Game.Components.Special.Init exposing (..)


scatterShot : Skill
scatterShot =
    { kind = SpecialSkill
    , name = "Scatter Shot"
    , effect = { defaultEffect | hp = 30 }
    , range = AllFront
    , element = None
    , cost = 100
    }


airBlade : Skill
airBlade =
    { kind = SpecialSkill
    , name = "Air Blade"
    , effect = { defaultEffect | hp = 80 }
    , range = One
    , element = None
    , cost = 100
    }


compounding : Skill
compounding =
    { kind = SpecialSkill
    , name = "Compounding"
    , effect = defaultEffect
    , range = Oneself
    , element = None
    , cost = 100
    }


arcaneBeam : Skill
arcaneBeam =
    { kind = Magic
    , name = "Arcane Beam"
    , effect = { defaultEffect | hp = 40 }
    , range = One
    , element = None
    , cost = 4
    }


fireBall : Skill
fireBall =
    { kind = Magic
    , name = "Fire Ball"
    , effect = { defaultEffect | hp = 40 }
    , range = Region
    , element = Fire
    , cost = 12
    }

restorationPotion : Skill
restorationPotion =
    { kind = Item
    , name = "Restoration Potion"
    , effect = { defaultEffect | hp = -40 }
    , range = Ally
    , element = None
    , cost = 0
    }

magicWater : Skill
magicWater =
    { kind = Item
    , name = "Magic Water"
    , effect = { defaultEffect | mp = -20 }
    , range = Ally
    , element = None
    , cost = 0
    }

poison : Skill
poison =
    { kind = Item
    , name = "Poison"
    , effect = { defaultEffect | hp = -40 }
    , range = Ally
    , element = None
    , cost = 0
    }
