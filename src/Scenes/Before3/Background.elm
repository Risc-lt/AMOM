module Scenes.Before3.Background exposing (..)

{-
   background data
-}

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


followDown : Camera
followDown =
    genCamera 0 -1500 5 2


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
        { backFigure = "dialogue_3"
        , x = 0
        , y = 0
        , w = 1920
        , h = 3080
        }
    , curMove = defaultCamera
    , remainMove =
        [ followDown
        ]
    }
