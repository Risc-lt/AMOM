module SceneProtos.Story.Components.CharSequence.RenderHelper exposing (renderHelper)

{-|


# RenderHelper module

@docs renderHelper

-}

import Canvas
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Lib.UserData exposing (UserData)
import Messenger.Base
import Messenger.Render.Sprite exposing (renderSprite, renderSpriteWithRev)
import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), Posture(..))
import SceneProtos.Story.Components.ComponentBase exposing (BaseData)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


checkReverse : Character -> Bool
checkReverse char =
    let
        isRight =
            char.direction == Right
    in
    if List.member char.name [ "Bruce", "Wenderd", "Cavalry", "Bulingze", "Bithif" ] then
        isRight

    else
        not isRight


renderChar : Character -> String -> String -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderChar char name act env =
    if char.posture == Fall then
        renderSprite
            env.globalData.internalData
            [ imageSmoothing False ]
            ( char.x, char.y )
            ( 140, 140 )
            (name ++ "Fall")

    else
        let
            row =
                case char.direction of
                    Up ->
                        "4"

                    Down ->
                        "3"

                    _ ->
                        if char.isMoving == False then
                            "0"

                        else if char.posture == Normal then
                            "2"

                        else
                            "1"
        in
        renderSpriteWithRev
            (checkReverse char)
            env.globalData.internalData
            [ imageSmoothing False ]
            ( char.x, char.y )
            ( 140, 140 )
            (name ++ "Sheet." ++ row ++ "/" ++ act)


{-| the helper function of view
-}
renderHelper : Character -> BaseData -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderHelper char basedata env =
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
    renderChar char name currentAct env
