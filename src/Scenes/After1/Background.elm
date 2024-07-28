module Scenes.After1.Background exposing (..)

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
        { backFigure = "dialogue_1"
        , x = -439
        , y = -300
        }
    , curMove = defaultCamera
    , remainMove =
        []
    }
