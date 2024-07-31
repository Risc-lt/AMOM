module SceneProtos.Game.Components.Self.RenderChar exposing
    ( renderChar
    , renderRegion
    )

import Canvas exposing (empty)
import Canvas.Settings exposing (stroke)
import Canvas.Settings.Advanced exposing (imageSmoothing, rotate, transform)
import Color
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), ComponentMsg(..), Gamestate(..), InitMsg(..), StatusMsg(..))
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| The initial data for the StroryTrigger component
-}
renderChar : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderChar char env =
    let
        gd =
            env.globalData

        rate =
            300

        currentAct x =
            String.fromInt (modBy (rate * x) gd.sceneStartTime // rate)
    in
    if char.hp /= 0 then
        if char.isAttacked then
            renderSprite
                env.globalData.internalData
                [ [ rotate (30 * pi / 180) ] |> transform ]
                ( char.x + 40, char.y - 30 )
                ( 100, 100 )
                (char.name ++ "Sheet.1/2")

        else if char.isRunning then
            renderSprite
                env.globalData.internalData
                [ imageSmoothing False ]
                ( char.x, char.y )
                ( 100, 100 )
                (char.name ++ "Sheet.1/" ++ currentAct 4)

        else
            Canvas.group []
                [ renderSprite
                    env.globalData.internalData
                    [ imageSmoothing False ]
                    ( char.x, char.y )
                    ( 100, 100 )
                    (char.name ++ "Sheet.0/" ++ currentAct 4)
                ]

    else
        empty


{-| The initial data for the StroryTrigger component
-}
renderRegion : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderRegion char env =
    let
        color =
            if char.state == Waiting then
                Color.black

            else
                Color.green
    in
    Canvas.shapes
        [ stroke color ]
        [ rect env.globalData.internalData ( char.x - 5, char.y - 5 ) ( 110, 110 ) ]
