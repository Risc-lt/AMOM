module SceneProtos.Story.Components.Background.Init exposing 
    (InitData
    , defaultCamera, MoveKind(..))

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
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    { background : Background
    , curMove : Camera
    , remainMove : List Camera
    }


defaultCamera : Camera
defaultCamera =
    { movekind = None
    , isMoving = False
    }
