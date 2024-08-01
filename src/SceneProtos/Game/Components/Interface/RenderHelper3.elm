module SceneProtos.Game.Components.Interface.RenderHelper3 exposing (renderAction, renderStatus)

import Canvas exposing (Renderable, empty, lineTo, moveTo, path)
import Canvas.Settings exposing (stroke)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Color
import Debug exposing (toString)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import SceneProtos.Game.Components.ComponentBase exposing (ActionType(..), BaseData, ComponentMsg(..), Gamestate(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.Interface.RenderHelper exposing (..)
import SceneProtos.Game.Components.Interface.RenderHelper2 exposing (..)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Self.UpdateOne exposing (checkIndex)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..), defaultSkill)
import SceneProtos.Game.Components.Special.Item exposing (..)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| check the mouse position
-}
checkMouse : Float -> Messenger.Base.Env SceneCommonData UserData -> Bool
checkMouse y env =
    let
        ( mouseX, mouseY ) =
            env.globalData.mousePos
    in
    if 1630 < mouseX && mouseX < 1870 && y + 15 < mouseY && mouseY < y + 100 then
        True

    else
        False


{-| render status
-}
renderStatus : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderStatus self env =
    let
        y =
            case self.name of
                "Wenderd" ->
                    40

                "Bruce" ->
                    250

                "Bulingze" ->
                    460

                "Bithif" ->
                    670

                _ ->
                    880

        color =
            if self.hp == 0 then
                Color.red

            else
                Color.black
    in
    if self.name /= "" then
        if checkMouse (y + 20) env then
            Canvas.group []
                [ renderSprite env.globalData.internalData [ imageSmoothing False ] ( 1470, y ) ( 160, 160 ) (self.name ++ "Sheet.0/1")
                , renderOneAttribute y self.attributes.strength "Strength" env
                , renderOneAttribute (y + 20) self.attributes.dexterity "Dexterity" env
                , renderOneAttribute (y + 40) self.attributes.constitution "Constitution" env
                , renderOneAttribute (y + 60) self.attributes.intelligence "Intelligence" env
                , renderBuff self.buff env 1675 (toFloat y + 120)
                , renderTextWithColorStyle env.globalData.internalData 20 self.name "Comic Sans MS" color "" ( 1675, y + 27.5 )
                ]

        else
            Canvas.group []
                [ renderSprite env.globalData.internalData [ imageSmoothing False ] ( 1470, y ) ( 160, 160 ) (self.name ++ "Sheet.0/1")
                , renderOneBar y self.hp self.extendValues.basicStatus.maxHp "HP" Color.red env
                , renderOneBar (y + 20) self.mp self.extendValues.basicStatus.maxMp "MP" Color.blue env
                , renderOneBar (y + 40) self.energy 300 "En" Color.green env
                , renderBuff self.buff env 1675 (toFloat y + 120)
                , renderTextWithColorStyle env.globalData.internalData 20 self.name "Comic Sans MS" color "" ( 1675, y + 27.5 )
                ]

    else
        empty


{-| Render the action
-}
renderAction : Env cdata userdata -> Data -> BaseData -> Renderable
renderAction env data basedata =
    let
        self =
            if basedata.curSelf <= 6 then
                Maybe.withDefault { defaultSelf | position = 0 } <|
                    List.head <|
                        List.filter (\x -> x.position == basedata.curSelf && x.hp /= 0) data.selfs

            else
                defaultSelf

        name =
            if self.name /= "" then
                self.name ++ "'s"

            else
                ""

        actionBar =
            case basedata.state of
                GameBegin ->
                    renderChangePosition env data basedata

                PlayerTurn ->
                    renderPlayerTurn env name

                TargetSelection _ ->
                    renderTargetSelection env data basedata name

                ChooseSpeSkill ->
                    renderChooseSkill env self name basedata.state

                ChooseMagic ->
                    renderChooseSkill env self name basedata.state

                ChooseItem ->
                    renderChooseSkill env self name basedata.state

                Compounding ->
                    renderChooseSkill env self name basedata.state

                _ ->
                    empty
    in
    Canvas.group []
        [ Canvas.shapes
            [ stroke Color.black ]
            [ path (posToReal env.globalData.internalData ( 320, 715 )) [ lineTo (posToReal env.globalData.internalData ( 320, 1060 )) ] ]
        , actionBar
        ]
