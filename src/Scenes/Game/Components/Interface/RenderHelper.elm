module Scenes.Game.Components.Interface.RenderHelper exposing (..)

import Canvas exposing (Renderable, empty, lineTo, moveTo, path)
import Canvas.Settings exposing (fill, stroke)
import Color
import Debug exposing (toString)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import Scenes.Game.Components.Interface.Init exposing (InitData, defaultUI)
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


renderOneBar : Float -> Int -> Int -> String -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderOneBar y val upperBound valType env =
    Canvas.group []
        [ Canvas.shapes
            [ fill Color.red ]
            [ rect env.globalData.internalData ( 1675, y + 57.5 ) ( 150 * (toFloat val / toFloat upperBound), 15 ) ]
        , Canvas.shapes
            [ stroke Color.black ]
            [ rect env.globalData.internalData ( 1675, y + 57.5 ) ( 150, 15 ) ]
        , renderTextWithColorCenter env.globalData.internalData 20 valType "Arial" Color.black ( 1650, y + 65 )
        , renderTextWithColorCenter env.globalData.internalData 20 (toString <| val) "Arial" Color.black ( 1850, y + 65 )
        ]


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
                    0

        color =
            if self.hp == 0 then
                Color.red

            else
                Color.black
    in
    if self.name /= "" then
        Canvas.group []
            [ renderSprite env.globalData.internalData [] ( 1470, y ) ( 160, 160 ) self.name
            , renderOneBar y self.hp self.extendValues.basicStatus.maxHp "HP" env
            , renderOneBar (y + 20) self.mp self.extendValues.basicStatus.maxMp "MP" env
            , renderOneBar (y + 40) self.energy 300 "En" env
            , renderTextWithColorStyle env.globalData.internalData 20 self.name "Arial" color "" ( 1675, y + 27.5 )
            ]

    else
        empty


renderChangePosition : Env cdata userdata -> Data -> BaseData -> Renderable
renderChangePosition env data basedata =
    if basedata.state == GameBegin then
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
            [ renderTextWithColorCenter env.globalData.internalData 60 "Positon" "Arial" Color.black ( 160, 820 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Changing" "Arial" Color.black ( 160, 940 )
            , renderTextWithColorCenter env.globalData.internalData 60 name "Arial" Color.black ( 870, 880 )
            ]

    else
        empty


renderPlayerTurn : Env cdata userdata -> Data -> BaseData -> Renderable
renderPlayerTurn env data basedata =
    if basedata.state == PlayerTurn then
        let
            target =
                if basedata.curSelf <= 6 then
                    Maybe.withDefault { defaultSelf | position = 0 } <|
                        List.head <|
                            List.filter (\x -> x.position == basedata.curSelf && x.hp /= 0) data.selfs

                else
                    defaultSelf

            name =
                if target.name /= "" then
                    target.name ++ "'s"

                else
                    ""
        in
        Canvas.group []
            [ renderTextWithColorCenter env.globalData.internalData 60 name "Arial" Color.black ( 160, 820 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Turn" "Arial" Color.black ( 160, 930 )
            , Canvas.shapes
                [ stroke Color.black ]
                [ path (posToReal env.globalData.internalData ( 540, 680 ))
                    [ lineTo (posToReal env.globalData.internalData ( 540, 1080 ))
                    , moveTo (posToReal env.globalData.internalData ( 760, 680 ))
                    , lineTo (posToReal env.globalData.internalData ( 760, 1080 ))
                    , moveTo (posToReal env.globalData.internalData ( 980, 680 ))
                    , lineTo (posToReal env.globalData.internalData ( 980, 1080 ))
                    , moveTo (posToReal env.globalData.internalData ( 1200, 680 ))
                    , lineTo (posToReal env.globalData.internalData ( 1200, 1080 ))
                    ]
                ]
            , renderTextWithColorCenter env.globalData.internalData 60 "Attack" "Arial" Color.black ( 430, 880 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Defence" "Arial" Color.black ( 650, 880 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Special" "Arial" Color.black ( 870, 820 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Skills" "Arial" Color.black ( 870, 930 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Magics" "Arial" Color.black ( 1090, 880 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Items" "Arial" Color.black ( 1310, 880 )
            ]

    else
        empty


renderTargetSelection : Env cdata userdata -> Data -> BaseData -> Renderable
renderTargetSelection env data basedata =
    if basedata.state == TargetSelection then
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

            remainEnemy =
                List.map (\x -> x.position - 6) <|
                    List.filter (\x -> x.hp /= 0) <|
                        data.enemies
        in
        Canvas.group []
            ([ renderTextWithColorCenter env.globalData.internalData 60 name "Arial" Color.black ( 160, 820 )
             , renderTextWithColorCenter env.globalData.internalData 60 "Turn" "Arial" Color.black ( 160, 930 )
             , Canvas.shapes
                [ stroke Color.black ]
                [ path (posToReal env.globalData.internalData ( 640, 680 ))
                    [ lineTo (posToReal env.globalData.internalData ( 640, 1080 ))
                    , moveTo (posToReal env.globalData.internalData ( 1030, 680 ))
                    , lineTo (posToReal env.globalData.internalData ( 1030, 1080 ))
                    , moveTo (posToReal env.globalData.internalData ( 640, 813.3 ))
                    , lineTo (posToReal env.globalData.internalData ( 1420, 813.3 ))
                    , moveTo (posToReal env.globalData.internalData ( 640, 946.6 ))
                    , lineTo (posToReal env.globalData.internalData ( 1420, 946.6 ))
                    ]
                ]
             , renderTextWithColorCenter env.globalData.internalData 60 "Target" "Arial" Color.black ( 480, 820 )
             , renderTextWithColorCenter env.globalData.internalData 60 "Selection" "Arial" Color.black ( 480, 930 )
             ]
                ++ List.map
                    (\x ->
                        renderTextWithColorCenter env.globalData.internalData
                            60
                            "Monster"
                            "Arial"
                            Color.black
                            ( toFloat (1225 - (x - 1) // 3 * 390)
                            , toFloat ((x - (x - 1) // 3 * 3) - 1) * 133.3 + 746.65
                            )
                    )
                    remainEnemy
            )

    else
        empty


renderAction : Env cdata userdata -> Data -> BaseData -> Renderable
renderAction env data basedata =
    Canvas.group []
        [ Canvas.shapes
            [ stroke Color.black ]
            [ path (posToReal env.globalData.internalData ( 320, 680 )) [ lineTo (posToReal env.globalData.internalData ( 320, 1080 )) ] ]
        , renderChangePosition env data basedata
        , renderPlayerTurn env data basedata
        , renderTargetSelection env data basedata
        ]
