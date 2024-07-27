module SceneProtos.Game.Components.Interface.RenderHelper exposing (..)

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
import SceneProtos.Game.Components.ComponentBase exposing (ActionType(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import SceneProtos.Game.Components.Interface.Init exposing (InitData, defaultUI)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), Skill, SpecialType(..))
import SceneProtos.Game.Components.Special.Library exposing (magicWater, poison)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


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
            , renderOneBar y self.hp self.extendValues.basicStatus.maxHp "HP" Color.red env
            , renderOneBar (y + 20) self.mp self.extendValues.basicStatus.maxMp "MP" Color.blue env
            , renderOneBar (y + 40) self.energy 300 "En" Color.green env
            , renderBuff self.buff env 1675 (toFloat y + 120)
            , renderTextWithColorStyle env.globalData.internalData 20 self.name "Comic Sans MS" color "" ( 1675, y + 27.5 )
            ]

    else
        empty


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
               ]
        )


renderTargetSelection : Env cdata userdata -> Data -> BaseData -> String -> Renderable
renderTargetSelection env data basedata name =
    let
        isAlly =
            case basedata.state of
                TargetSelection (Skills skill) ->
                    skill.range == Ally

                _ ->
                    False

        remainEnemies =
            List.map (\x -> { x | position = x.position - 6 }) <|
                List.filter (\x -> x.hp /= 0) <|
                    data.enemies

        remainSelfs =
            List.filter (\x -> x.hp /= 0) <|
                data.selfs

        renderTargets =
            if isAlly then
                List.map
                    (\x ->
                        renderTextWithColorCenter env.globalData.internalData
                            60
                            x.name
                            "Comic Sans MS"
                            Color.black
                            ( toFloat (835 + (x.position - 1) // 3 * 390)
                            , toFloat ((x.position - (x.position - 1) // 3 * 3) - 1) * 133.3 + 746.65
                            )
                    )
                    remainSelfs

            else
                List.map
                    (\x ->
                        renderTextWithColorCenter env.globalData.internalData
                            60
                            x.name
                            "Comic Sans MS"
                            Color.black
                            ( toFloat (1225 - (x.position - 1) // 3 * 390)
                            , toFloat ((x.position - (x.position - 1) // 3 * 3) - 1) * 133.3 + 746.65
                            )
                    )
                    remainEnemies
    in
    Canvas.group []
        ([ renderTextWithColorCenter env.globalData.internalData 60 name "Comic Sans MS" Color.black ( 160, 820 )
         , renderTextWithColorCenter env.globalData.internalData 60 "Turn" "Comic Sans MS" Color.black ( 160, 930 )
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
         , renderTextWithColorCenter env.globalData.internalData 60 "Target" "Comic Sans MS" Color.black ( 480, 820 )
         , renderTextWithColorCenter env.globalData.internalData 60 "Selection" "Comic Sans MS" Color.black ( 480, 930 )
         ]
            ++ renderTargets
        )


renderChooseSkill : Env cdata userdata -> Self -> String -> Gamestate -> Renderable
renderChooseSkill env self name state =
    let
        ( kind, prompt ) =
            if state == ChooseSpeSkill then
                ( SpecialSkill, "Spe Skill" )

            else if state == ChooseMagic then
                ( Magic, "Magic" )

            else if state == ChooseItem then
                ( Item, "Item" )

            else
                ( Item, "Compound" )

        skills =
            let
                targets =
                    List.indexedMap Tuple.pair <|
                        List.sortBy .cost <|
                            List.filter (\s -> s.kind == kind) <|
                                self.skills

                addPoison =
                    if List.any (\i -> (Tuple.second i).name == "Poison") targets then
                        targets

                    else
                        targets ++ [ ( List.length targets, poison ) ]

                addMagicWater =
                    if List.any (\i -> (Tuple.second i).name == "Magic Water") targets then
                        addPoison

                    else
                        addPoison ++ [ ( List.length addPoison, magicWater ) ]
            in
            if state == Compounding then
                addMagicWater

            else
                targets
    in
    Canvas.group []
        ([ renderTextWithColorCenter env.globalData.internalData 60 name "Comic Sans MS" Color.black ( 160, 820 )
         , renderTextWithColorCenter env.globalData.internalData 60 "Turn" "Comic Sans MS" Color.black ( 160, 930 )
         , Canvas.shapes
            [ stroke Color.black ]
            [ path (posToReal env.globalData.internalData ( 640, 680 ))
                [ lineTo (posToReal env.globalData.internalData ( 640, 1080 )) ]
            ]
         , renderTextWithColorCenter env.globalData.internalData 60 prompt "Comic Sans MS" Color.black ( 480, 820 )
         , renderTextWithColorCenter env.globalData.internalData 60 "Selection" "Comic Sans MS" Color.black ( 480, 930 )
         ]
            ++ List.map
                (\x ->
                    renderTextWithColorStyle env.globalData.internalData
                        40
                        (.name <| Tuple.second x)
                        "Comic Sans MS"
                        Color.black
                        ""
                        ( 660
                        , toFloat (Tuple.first x * 88 + 728)
                        )
                )
                skills
            ++ List.map
                (\x ->
                    renderTextWithColorCenter env.globalData.internalData
                        40
                        (toString <| .cost <| Tuple.second x)
                        "Comic Sans MS"
                        Color.black
                        ( 1380
                        , toFloat (Tuple.first x * 88 + 748)
                        )
                )
                skills
        )


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
            [ path (posToReal env.globalData.internalData ( 320, 680 )) [ lineTo (posToReal env.globalData.internalData ( 320, 1080 )) ] ]
        , actionBar
        ]
