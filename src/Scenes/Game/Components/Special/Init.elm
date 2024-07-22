module Scenes.Game.Components.Special.Init exposing
    ( Skill
    , Element(..), Range(..), SpecialType(..), defaultEffect, defaultSkill
    )

{-|


# Init module

@docs Skill

-}


type SpecialType
    = Magic
    | SpecialSkill


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


type alias Skill =
    { kind : SpecialType
    , name : String
    , effect : Effect
    , range : Range
    , element : Element
    , cost : Int
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
    , range = One
    , element = None
    , cost = 0
    }
