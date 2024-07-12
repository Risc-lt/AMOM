module SceneProtos.Story.Components.Wenderd.Init exposing (InitData)

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
