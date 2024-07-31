module SceneProtos.Game.Components.Special.Init exposing
    ( Skill
    , Buff(..), Element(..), Range(..), SpecialType(..)
    , defaultEffect, defaultSkill
    )

{-|


# Init module

@docs Skill
@docs Buff, Element, Range, SpecialType
@docs defaultEffect, defaultSkill

-}


{-| The type of special skills
-}
type SpecialType
    = Magic
    | SpecialSkill
    | Item


{-| The effect of the skill
-}
type alias Effect =
    { hp : Int
    , mp : Int
    , energy : Int
    }


{-| The range of the skill
-}
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


{-| The type of the skill
-}
type Element
    = Water
    | Fire
    | Air
    | Earth
    | None


{-| The type of the buff
-}
type Buff
    = AttackUp Int
    | DefenceUp Int
    | SpeedUp Int
    | SpeedDown Int
    | HitRateUp Int
    | CriticalRateUp Int
    | ExtraAttack
    | NoAction
    | LoseHp


{-| The data structure for the skill
-}
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


{-| The default effect
-}
defaultEffect : Effect
defaultEffect =
    { hp = 0
    , mp = 0
    , energy = 0
    }


{-| The default skill
-}
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
