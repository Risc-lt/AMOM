module SceneProtos.Game.Components.Interface.RenderHelper3 exposing (..)


import Canvas exposing (Renderable, empty, lineTo, moveTo, path)
import Canvas.Settings exposing (stroke)
import Color
import Debug exposing (toString)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import SceneProtos.Game.Components.ComponentBase exposing (ActionType(..), BaseData, ComponentMsg(..), Gamestate(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.Interface.RenderHelper exposing (Data, renderChangePosition, renderPlayerTurn)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Self.UpdateOne exposing (checkIndex)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..), defaultSkill)
import SceneProtos.Game.Components.Special.Item exposing (..)
import SceneProtos.Game.Components.Interface.RenderHelper exposing (..)
import SceneProtos.Game.Components.Interface.RenderHelper2 exposing (..)


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
