module Scenes.After1.Background exposing (backgroundInitData, genCamera)

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


{-| The initial data for the background
-}
backgroundInitData : InitData
backgroundInitData =
    { background =
        { backFigure = "dialogue_1"
        , x = -439
        , y = -300
        , w = 2559
        , h = 1380
        }
    , curMove = defaultCamera
    , remainMove =
        []
    }
