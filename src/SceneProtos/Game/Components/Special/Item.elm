module SceneProtos.Game.Components.Special.Item exposing (energyWater, restorationPotion, poison, magicWater)

{-|


# Item module

This module contains the items for the game.

@docs magicWater, energyWater, poison, restorationPotion

-}

import SceneProtos.Game.Components.Special.Init exposing (..)


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
