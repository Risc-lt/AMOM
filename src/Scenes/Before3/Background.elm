module Scenes.Before3.Background exposing (backgroundInitData)

{-| #Background module

This module contains the background data for the Before3 scene.

@docs backgroundInitData

-}

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


followDown : Camera
followDown =
    genCamera 0 -1000 5 2


check : Camera
check =
    genCamera 0 -2000 8 6


followUp : Camera
followUp =
    genCamera 0 -1000 8 15


genCamera : Float -> Float -> Float -> Int -> Camera
genCamera targetX targetY speed id =
    { defaultCamera
        | targetX = targetX
        , targetY = targetY
        , speed = speed
        , isMoving = False
        , id = id
    }


{-| The initial data for the background
-}
backgroundInitData : InitData
backgroundInitData =
    { background =
        { backFigure = "dialogue_3"
        , x = 0
        , y = 0
        , w = 1920
        , h = 3080
        }
    , curMove = defaultCamera
    , remainMove =
        [ followDown
        , check
        , followUp
        ]
    }
