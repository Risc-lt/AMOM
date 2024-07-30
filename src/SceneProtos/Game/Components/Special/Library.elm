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


arcaneBeam : Skill
arcaneBeam =
    { kind = Magic
    , name = "Arcane Beam"
    , effect = { defaultEffect | hp = 40 }
    , buff = []
    , range = One
    , element = None
    , cost = 4
    , lasting = 0
    }


fireBall : Skill
fireBall =
    { kind = Magic
    , name = "Fire Ball"
    , effect = { defaultEffect | hp = 40 }
    , buff = []
    , range = Region
    , element = Fire
    , cost = 12
    , lasting = 0
    }


restorationPotion : Skill
restorationPotion =
    { kind = Item
    , name = "Restoration Potion"
    , effect = { defaultEffect | hp = -40 }
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
    , effect = { defaultEffect | hp = -40 }
    , buff = []
    , range = Ally
    , element = None
    , cost = 0
    , lasting = 0
    }
