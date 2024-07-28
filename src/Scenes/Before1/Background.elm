module Scenes.Before1.Background exposing (..)

{-
   background data
-}

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


followRight : Camera
followRight =
    genCamera -639 -300 8 2


followLeft : Camera
followLeft =
    genCamera 0 -300 8 5


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
        , x = 0
        , y = -300
        }
    , curMove = defaultCamera
    , remainMove =
        [ followRight
        , followLeft
        ]
    }
