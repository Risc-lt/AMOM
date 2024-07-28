module Scenes.Before1.Background exposing (..)

{-
   background data
-}

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


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
        { backFigure = "Background"
        , x = 0
        , y = 0
        }
    , curMove = defaultCamera
    , remainMove = []
    }
