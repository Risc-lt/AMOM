module SceneProtos.Game.Components.StoryTrigger.Init exposing
    ( InitData
    , HealthStatus(..), TriggerConditions(..), defaultTrigger
    )

{-|


# Init module

@docs InitData

-}


{-| The data used to initialize the scene
-}
type alias InitData =
    List ( TriggerConditions, Int )


type HealthStatus
    = Half
    | Zero


{-| The conditions that trigger the story
-}
type TriggerConditions
    = FrameTrigger Int
    | HpTrigger HealthStatus String
    | StateTrigger String


{-| The initial data for the StroryTrigger component
-}
defaultTrigger : ( TriggerConditions, Int )
defaultTrigger =
    ( FrameTrigger 0, 0 )
