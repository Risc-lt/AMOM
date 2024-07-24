module Scenes.Game.Components.StoryTrigger.Init exposing
    ( InitData
    , TriggerConditions, emptyInitData
    )

{-|


# Init module

@docs InitData

-}


{-| The data used to initialize the scene
-}
type alias InitData =
    List TriggerConditions


{-| The conditions that trigger the story
-}
type alias TriggerConditions =
    { side : String
    , frameNum : Int
    , hpTrigger : Int
    , gameState : String
    }


{-| The initial data for the StroryTrigger component
-}
emptyInitData : InitData
emptyInitData =
    []
