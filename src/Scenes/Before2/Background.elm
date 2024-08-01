module Scenes.Before2.Background exposing (backgroundInitData)

{-| #Background module

This module contains the background data for the Before2 scene.

@docs backgroundInitData

-}

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


followRight : Camera
followRight =
    genCamera -300 -300 8 5


charge : Camera
charge =
    genCamera 0 -300 8 15


genCamera : Float -> Float -> Float -> Int -> Camera
genCamera targetX targetY speed id =
    { defaultCamera
        | targetX = targetX
        , targetY = targetY
        , speed = speed
        , isMoving = False
        , id = id
    }


backgroundInitData : InitData
backgroundInitData =
    { background =
        { backFigure = "dialogue_1"
        , x = -639
        , y = -300
        , w = 2559
        , h = 1380
        }
    , curMove = defaultCamera
    , remainMove =
        [ followRight
        , charge
        ]
    }
