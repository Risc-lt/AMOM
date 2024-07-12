module SceneProtos.Story.Components.Bruce.Init exposing (InitData)

{-|


# Init module

@docs InitData

-}


{-| The data used to initialize the scene
-}
type alias InitData =
    { spriteSheet : String
    , currentFrame : Int
    , frameCount : Int
    , position : ( Float, Float )
    }
