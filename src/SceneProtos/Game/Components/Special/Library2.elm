module SceneProtos.Game.Components.Special.Library2 exposing (blessingOfAir, chainLightning, energyWater, lightningSpell, magicWater, mudSwamp, poison, restorationPotion, stoneSkin)

{-|


# Library2 module

This module contains the special skills for the game.

@docs blessingOfAir, chainLightning, energyWater, lightningSpell, magicWater, mudSwamp, poison, restorationPotion, stoneSkin

-}

import SceneProtos.Game.Components.Special.Init exposing (..)


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


{-| Skill: Restoration Potion
-}
restorationPotion : Skill
restorationPotion =
    { kind = Item
    , name = "Restoration Potion"
    , effect = { defaultEffect | hp = -80 }
    , buff = []
    , range = Ally
    , element = None
    , cost = 0
    , lasting = 0
    , content = 
        [ "Use on an ally."
        , "80 health points restoration"
        , "opposite for the cemetary races"
        ]
    }


{-| Skill: Magic Water
-}
magicWater : Skill
magicWater =
    { kind = Item
    , name = "Magic Water"
    , effect = { defaultEffect | mp = -20 }
    , buff = []
    , range = Ally
    , element = None
    , cost = 0
    , lasting = 0
    , content = 
        [ "Use on an ally."
        , "20 magic points restoration"
        ]
    }


{-| Skill: Poison
-}
poison : Skill
poison =
    { kind = Item
    , name = "Poison"
    , effect = { defaultEffect | hp = 80 }
    , buff = []
    , range = Ally
    , element = None
    , cost = 0
    , lasting = 0
    , content = 
        [ "Use on an ally."
        , "80 damage"
        , "opposite for the cemetary races"
        ]
    }


{-| Skill: Energy Water
-}
energyWater : Skill
energyWater =
    { kind = Item
    , name = "Energy Water"
    , effect = { defaultEffect | energy = -100 }
    , buff = []
    , range = Ally
    , element = None
    , cost = 0
    , lasting = 0
    , content = 
        [ "Use on an ally."
        , "100 energy restoration"
        ]
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
