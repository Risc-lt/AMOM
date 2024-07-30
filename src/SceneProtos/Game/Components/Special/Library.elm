module SceneProtos.Game.Components.Special.Library exposing (..)

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

import SceneProtos.Game.Components.Special.Init exposing (..)


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


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
    }


restorationPotion : Skill
restorationPotion =
    { kind = Item
    , name = "Restoration Potion"
    , effect = { defaultEffect | hp = 80 }
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
    , effect = { defaultEffect | hp = -80 }
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
