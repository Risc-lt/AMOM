module SceneProtos.Story.Components.Background.Init exposing
    ( InitData
    , Background, Camera, defaultBackground, defaultCamera
    )

{-|


# Init module

@docs InitData

-}

{- The data structure for the background -}


type alias Background =
    { backFigure : String
    , x : Float
    , y : Float
    , w : Float
    , h : Float
    }



{- The data structure for background movement -}


type alias Camera =
    { targetX : Float
    , targetY : Float
    , speed : Float
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
    , w = 0
    , h = 0
    }


defaultCamera : Camera
defaultCamera =
    { targetX = 0
    , targetY = 0
    , speed = 0
    , isMoving = False
    , id = 0
    }
