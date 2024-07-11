module SceneProtos.Story.Components.Character.Init exposing (InitData)

{-|


# Init module

@docs InitData

-}
type Direction
    = Up
    | Down
    | Right
    | Left

{-| The data used to initialize the scene
-}
type alias InitData =
    { name : String
    , velocity : Float
    , x : Float
    , y : Float
    , direction : Direction
    }
