module SceneProtos.Story.Components.Background.Init exposing 
    (InitData
    , defaultCamera, defaultBackground, MoveKind(..), Background, Camera)

{-|


# Init module

@docs InitData

-}


{- The data structure for the background
-}
type alias Background =
    { backFigure : String
    , x : Float
    , y : Float
    }


type MoveKind
    = Follow String
    | BySelf ( Float, Float ) Float
    | None


{- The data structure for background movement
-}
type alias Camera =
    { movekind : MoveKind
    , isMoving : Bool
    , id : Int
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    { background : Background
    , curMove : Camera
    , remainMove : List Camera
    }


defaultBackground : Background
defaultBackground =
    { backFigure = ""
    , x = 0
    , y = 0
    }


defaultCamera : Camera
defaultCamera =
    { movekind = None
    , isMoving = False
    , id = 0
    }
