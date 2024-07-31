module SceneProtos.Game.Components.Special.Library2 exposing (..)

{-
   Skill library 2
-}

import SceneProtos.Game.Components.Special.Init exposing (..)


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }
