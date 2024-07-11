module SceneProtos.Story.Components.Character.Init exposing (InitData)

{-|


# Init module

@docs InitData

-}

import Current exposing (Current)
import Messenger.Render.SpriteSheet exposing (SpriteSheet)


type Direction
    = Up
    | Down
    | Right
    | Left


{-| The data used to initialize the scene
-}
type alias InitData =
    { spriteSheet : String
    , currentFrame : Int
    , frameCount : Int
    , position : ( Float, Float )
    }
