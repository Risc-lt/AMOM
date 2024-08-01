module Scenes.After4.Background exposing (backgroundInitData, genCamera)

{-|


# Background module

This module is used to generate the background for the scene.

@docs backgroundInitData, genCamera

-}

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
        { backFigure = "dialogue_4"
        , x = -237
        , y = 0
        , w = 2157
        , h = 1080
        }
    , curMove = defaultCamera
    , remainMove = []
    }
