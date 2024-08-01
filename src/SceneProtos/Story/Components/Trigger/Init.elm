module SceneProtos.Story.Components.Trigger.Init exposing (InitData)

{-|


# Init module

@docs InitData

-}


{-| The data used to initialize the component of trigger
-}
type alias InitData =
    { id : Int
    , curPlot : List Int
    , overId : Int
    }
