module SceneProtos.Game.Components.StoryTrigger.Init exposing
    ( InitData
    , TriggerConditions(..)
    , defaultTrigger
    )

{-|


# Init module

@docs InitData
@docs TriggerConditions
@docs defaultTrigger

-}


{-| The data used to initialize the scene
-}
type alias InitData =
    List ( TriggerConditions, Int )


{-| The conditions that trigger the story
-}
type TriggerConditions
    = FrameTrigger Int
    | StateTrigger String
    | DieTrigger


{-| The initial data for the StroryTrigger component
-}
defaultTrigger : ( TriggerConditions, Int )
defaultTrigger =
    ( FrameTrigger 0, 0 )
