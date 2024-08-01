module Scenes.After2.Background exposing
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
        { backFigure = "dialogue_1"
        , x = 0
        , y = -300
        , w = 2559
        , h = 1380
        }
    , curMove = defaultCamera
    , remainMove =
        []
    }
