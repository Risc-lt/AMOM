module Scenes.After3.Background exposing
    ( backgroundInitData
    , genCamera
    )

import SceneProtos.Story.Components.Background.Init exposing (Camera, InitData, defaultCamera)


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
        { backFigure = "dialogue_3"
        , x = 0
        , y = -1500
        , w = 1920
        , h = 3080
        }
    , curMove = defaultCamera
    , remainMove = []
    }
