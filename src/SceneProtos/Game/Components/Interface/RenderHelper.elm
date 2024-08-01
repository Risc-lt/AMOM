module SceneProtos.Game.Components.Interface.RenderHelper exposing (..)

import Canvas exposing (Renderable, empty, lineTo, moveTo, path)
import Canvas.Settings exposing (fill, stroke)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Color
import Debug exposing (toString)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import SceneProtos.Game.Components.ComponentBase exposing (ActionType(..), BaseData, ComponentMsg(..), Gamestate(..))
import SceneProtos.Game.Components.Interface.Init exposing (InitData)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), SpecialType(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


{-| render an attribute
-}
renderOneAttribute : Float -> Int -> String -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderOneAttribute y val valType env =
    Canvas.group []
        [ renderTextWithColorCenter env.globalData.internalData 20 (valType ++ ":") "Comic Sans MS" Color.black ( 1710, y + 65 )
        , renderTextWithColorCenter env.globalData.internalData 20 (toString <| val) "Comic Sans MS" Color.black ( 1810, y + 65 )
        ]


{-| render a bar
-}
renderOneBar : Float -> Int -> Int -> String -> Color.Color -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderOneBar y val upperBound valType color env =
    Canvas.group []
        [ Canvas.shapes
            [ fill color ]
            [ rect env.globalData.internalData ( 1675, y + 57.5 ) ( 150 * (toFloat val / toFloat upperBound), 15 ) ]
        , Canvas.shapes
            [ stroke Color.black ]
            [ rect env.globalData.internalData ( 1675, y + 57.5 ) ( 150, 15 ) ]
        , renderTextWithColorCenter env.globalData.internalData 20 valType "Comic Sans MS" Color.black ( 1650, y + 65 )
        , renderTextWithColorCenter env.globalData.internalData 20 (toString <| val) "Comic Sans MS" Color.black ( 1850, y + 65 )
        ]


{-| render all buffs
-}
renderBuff : List ( Buff, Int ) -> Messenger.Base.Env SceneCommonData UserData -> Float -> Float -> Canvas.Renderable
renderBuff buffs env x y =
    let
        nameList =
            List.map
                (\( buff, _ ) ->
                    case buff of
                        AttackUp _ ->
                            "Brave"

                        DefenceUp _ ->
                            "Solid"

                        SpeedUp _ ->
                            "Acceleration"

                        SpeedDown _ ->
                            "Retard"

                        HitRateUp _ ->
                            "Concentration"

                        CriticalRateUp _ ->
                            "Precision"

                        ExtraAttack ->
                            "Bloodthirsty"

                        NoAction ->
                            "Seal"

                        LoseHp ->
                            "Bleed"
                )
                buffs

        buffViews =
            List.indexedMap
                (\index name ->
                    renderSprite env.globalData.internalData [] ( x + (toFloat index * 22), y ) ( 20, 20 ) name
                )
                nameList
    in
    Canvas.group [] buffViews


{-| render the position prompt
-}
renderChangePosition : Env cdata userdata -> Data -> BaseData -> Renderable
renderChangePosition env data basedata =
    let
        working =
            List.filter
                (\x ->
                    x.state == Working
                )
                data.selfs

        target =
            if List.length working == 1 then
                Maybe.withDefault defaultSelf (List.head working)

            else
                defaultSelf

        name =
            if target.name /= "" then
                target.name ++ " chosen"

            else
                "Nobody chosen"
    in
    Canvas.group []
        [ renderTextWithColorCenter env.globalData.internalData 60 "Positon" "Comic Sans MS" Color.black ( 160, 820 )
        , renderTextWithColorCenter env.globalData.internalData 60 "Changing" "Comic Sans MS" Color.black ( 160, 940 )
        , renderTextWithColorCenter env.globalData.internalData 60 name "Comic Sans MS" Color.black ( 870, 880 )
        ]


{-| render the actions
-}
renderPlayerTurn : Env cdata userdata -> String -> Renderable
renderPlayerTurn env name =
    let
        ( x, y ) =
            env.globalData.mousePos

        select =
            if x > 320 && x < 540 && y > 680 && y < 1080 then
                "Attack"

            else if x > 540 && x < 760 && y > 680 && y < 1080 then
                "Defence"

            else if x > 760 && x < 980 && y > 680 && y < 1080 then
                "Special"

            else if x > 980 && x < 1200 && y > 680 && y < 1080 then
                "Magics"

            else if x > 1200 && x < 1420 && y > 680 && y < 1080 then
                "Items"

            else
                ""

        selections =
            List.map
                (\str ->
                    let
                        amplify =
                            if str == select || (str == "Skills" && select == "Special") then
                                1.2

                            else
                                1.0

                        pos =
                            case str of
                                "Attack" ->
                                    ( 430, 880 )

                                "Defence" ->
                                    ( 650, 880 )

                                "Special" ->
                                    ( 870, 820 )

                                "Skills" ->
                                    ( 870, 930 )

                                "Magics" ->
                                    ( 1090, 880 )

                                "Items" ->
                                    ( 1310, 880 )

                                _ ->
                                    ( 0, 0 )
                    in
                    renderTextWithColorCenter env.globalData.internalData (60 * amplify) str "Comic Sans MS" Color.black pos
                )
                [ "Attack", "Defence", "Special", "Skills", "Magics", "Items" ]
    in
    Canvas.group []
        (selections
            ++ [ renderTextWithColorCenter env.globalData.internalData 60 name "Comic Sans MS" Color.black ( 160, 820 )
               , renderTextWithColorCenter env.globalData.internalData 60 "Turn" "Comic Sans MS" Color.black ( 160, 930 )
               , Canvas.shapes
                    [ stroke Color.black ]
                    [ path (posToReal env.globalData.internalData ( 540, 715 ))
                        [ lineTo (posToReal env.globalData.internalData ( 540, 1060 ))
                        , moveTo (posToReal env.globalData.internalData ( 760, 715 ))
                        , lineTo (posToReal env.globalData.internalData ( 760, 1060 ))
                        , moveTo (posToReal env.globalData.internalData ( 980, 715 ))
                        , lineTo (posToReal env.globalData.internalData ( 980, 1060 ))
                        , moveTo (posToReal env.globalData.internalData ( 1200, 715 ))
                        , lineTo (posToReal env.globalData.internalData ( 1200, 1060 ))
                        ]
                    ]
               ]
        )
