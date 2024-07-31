module SceneProtos.Game.Components.Interface.RenderHelper2 exposing (..)

import Canvas exposing (Renderable, empty, lineTo, moveTo, path)
import Canvas.Settings exposing (stroke)
import Color
import Debug exposing (toString)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import SceneProtos.Game.Components.ComponentBase exposing (ActionType(..), BaseData, ComponentMsg(..), Gamestate(..))
import SceneProtos.Game.Components.Interface.RenderHelper exposing (Data, renderChangePosition, renderPlayerTurn)
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..), Range(..), SpecialType(..))
import SceneProtos.Game.Components.Special.Library2 exposing (magicWater, poison)


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
                        let
                            ( mouseX, mouseY ) =
                                env.globalData.mousePos

                            amplify =
                                if
                                    mouseX
                                        > toFloat (1225 - (x.position - 1) // 3 * 390)
                                        - 100
                                        && mouseX
                                        < toFloat (1225 - (x.position - 1) // 3 * 390)
                                        + 100
                                        && mouseY
                                        > toFloat ((x.position - (x.position - 1) // 3 * 3) - 1)
                                        * 133.3
                                        + 700
                                        && mouseY
                                        < toFloat ((x.position - (x.position - 1) // 3 * 3) - 1)
                                        * 133.3
                                        + 800
                                then
                                    1.2

                                else
                                    1.0
                        in
                        renderTextWithColorCenter env.globalData.internalData
                            (60 * amplify)
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
            [ path (posToReal env.globalData.internalData ( 640, 715 ))
                [ lineTo (posToReal env.globalData.internalData ( 640, 1060 ))
                , moveTo (posToReal env.globalData.internalData ( 1030, 715 ))
                , lineTo (posToReal env.globalData.internalData ( 1030, 1060 ))
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

        skillView =
            List.map
                (\x ->
                    let
                        ( mouseX, mouseY ) =
                            env.globalData.mousePos

                        amplify =
                            if mouseX > 640 && mouseX < 900 && mouseY > toFloat (Tuple.first x * 88 + 728) && mouseY < toFloat (Tuple.first x * 88 + 816) then
                                1.2

                            else
                                1.0
                    in
                    renderTextWithColorStyle env.globalData.internalData
                        (40 * amplify)
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
    in
    Canvas.group []
        ([ renderTextWithColorCenter env.globalData.internalData 60 name "Comic Sans MS" Color.black ( 160, 820 )
         , renderTextWithColorCenter env.globalData.internalData 60 "Turn" "Comic Sans MS" Color.black ( 160, 930 )
         , Canvas.shapes
            [ stroke Color.black ]
            [ path (posToReal env.globalData.internalData ( 640, 715 ))
                [ lineTo (posToReal env.globalData.internalData ( 640, 1060 )) ]
            ]
         , renderTextWithColorCenter env.globalData.internalData 60 prompt "Comic Sans MS" Color.black ( 480, 820 )
         , renderTextWithColorCenter env.globalData.internalData 60 "Selection" "Comic Sans MS" Color.black ( 480, 930 )
         ]
            ++ skillView
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
            [ path (posToReal env.globalData.internalData ( 320, 715 )) [ lineTo (posToReal env.globalData.internalData ( 320, 1060 )) ] ]
        , actionBar
        ]
