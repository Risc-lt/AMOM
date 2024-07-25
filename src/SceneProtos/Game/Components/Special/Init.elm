module Scenes.Game.Components.Special.Init exposing
    ( Skill
    , Buff(..), Element(..), Range(..), SpecialType(..), defaultEffect, defaultSkill
    )

{-|


# Init module

@docs Skill

-}


type SpecialType
    = Magic
    | SpecialSkill
    | Item


type alias Effect =
    { hp : Int
    , mp : Int
    }


type Range
    = One
    | Chain
    | AllFront
    | Oneself
    | Ally
    | PenetrateOne
    | OneTheOther Effect
    | Region
    | AllEnemy


type Element
    = Water
    | Fire
    | Air
    | Earth
    | None


type Buff
    = AttackUp Int
    | DefenceUp Int
    | SpeedUp Int
    | SpeedDown Int
    | HitRateUp Int
    | CriticalRateUp Int
    | ExtraAttack
    | NoAction


type alias Skill =
    { kind : SpecialType
    , name : String
    , effect : Effect
    , buff : List Buff
    , range : Range
    , element : Element
    , cost : Int
    , lasting : Int
    }


defaultEffect : Effect
defaultEffect =
    { hp = 0
    , mp = 0
    }


defaultSkill : Skill
defaultSkill =
    { kind = Magic
    , name = ""
    , effect = defaultEffect
    , buff = []
    , range = One
    , element = None
    , cost = 0
    , lasting = 0
    }
