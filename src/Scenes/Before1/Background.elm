module Scenes.Before1.Background exposing (backgroundInitData, followLeft, followRight, wolfRight)

{-|


# Background module

This module is used to generate the background for the scene.

@docs backgroundInitData, followLeft, followRight, wolfRight

-}

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


{-| Camera: Follow right
-}
followRight : Camera
followRight =
    genCamera -639 -300 8 2


{-| Camera: Follow left
-}
followLeft : Camera
followLeft =
    genCamera 0 -300 8 10


{-| Camera: Wolf right
-}
wolfRight : Camera
wolfRight =
    genCamera -639 -300 8 12


{-| Generate a camera
-}
genCamera : Float -> Float -> Float -> Int -> Camera
genCamera targetX targetY speed id =
    { defaultCamera
        | targetX = targetX
        , targetY = targetY
        , speed = speed
        , isMoving = False
        , id = id
    }


{-| Background: Init data
-}
backgroundInitData : InitData
backgroundInitData =
    { background =
        { backFigure = "dialogue_1"
        , x = 0
        , y = -300
        , w = 2559
        , h = 1380
        }
    , curMove = defaultCamera
    , remainMove =
        [ followRight
        , followLeft
        , wolfRight
        ]
    }
