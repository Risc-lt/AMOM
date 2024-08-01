module SceneProtos.Story.Components.CharSequence.RenderHelper exposing (..)


import SceneProtos.Story.Components.CharSequence.Init exposing (Character)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData)
import Messenger.Base
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import Lib.UserData exposing (UserData)
import Canvas
import Messenger.Render.Sprite exposing (renderSprite)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import SceneProtos.Story.Components.CharSequence.Init exposing (Posture(..))


renderChar : Character -> BaseData -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderChar char basedata env =
    let
        gd =
            env.globalData

        stillRate =
            400

        moveRate =
            floor (1000 / char.speed)

        name =
            if
                List.any (\n -> String.endsWith n char.name)
                    [ "1", "2", "3", "4", "5", "6" ]
            then
                String.dropRight 1 char.name

            else
                char.name

        x =
            if name == "Wild Wolf" then
                if char.isMoving then
                    3

                else
                    2

            else
                4

        currentAct =
            if char.isMoving then
                String.fromInt (modBy (moveRate * x) gd.sceneStartTime // moveRate)

            else
                String.fromInt (modBy (stillRate * x) gd.sceneStartTime // stillRate)
    in
    if char.posture == Fall then
        renderSprite
            env.globalData.internalData
            [ imageSmoothing False ]
            ( char.x, char.y )
            ( 140, 140 )
            (name ++ "Fall")

    else
        if char.isMoving then
            renderSprite
                env.globalData.internalData
                [ imageSmoothing False ]
                ( char.x, char.y )
                ( 140, 140 )
                (name ++ "Sheet.1/" ++ currentAct)

        else
            Canvas.group []
                [ renderSprite
                    env.globalData.internalData
                    [ imageSmoothing False ]
                    ( char.x, char.y )
                    ( 140, 140 )
                    (name ++ "Sheet.0/" ++ currentAct)
                ]
