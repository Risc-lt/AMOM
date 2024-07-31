module SceneProtos.Story.Components.DialogSequence.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Canvas.Settings.Advanced exposing (alpha)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorStyle)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, DialogueState(..), InitData, defaultDialogue)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        DialogueInit deliver ->
            ( deliver, initBaseData )

        _ ->
            ( { curDialogue = defaultDialogue
              , remainDiaList = []
              }
            , initBaseData
            )


filterDialogue : List Dialogue -> Dialogue -> Bool -> List Dialogue
filterDialogue list curDia flag =
    List.filter
        (\dia ->
            if flag then
                dia.id == ( Tuple.first curDia.id, Tuple.second curDia.id + 1 )

            else
                dia.id /= ( Tuple.first curDia.id, Tuple.second curDia.id + 1 )
        )
        list


updateHelper : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateHelper env evnt data basedata =
    let
        curDia =
            data.curDialogue

        maybeNextDia =
            List.head <|
                filterDialogue data.remainDiaList curDia True

        ( nextDia, newBasedata, msg ) =
            case maybeNextDia of
                Just dia ->
                    ( { dia | state = Appear }, basedata, [] )

                _ ->
                    ( { curDia | state = NoDialogue }
                    , { basedata | isPlaying = False }
                    , [ Other ( "Trigger", PlotDone 3 ) ]
                    )
    in
    ( ( { data | curDialogue = nextDia, remainDiaList = filterDialogue data.remainDiaList curDia False }, newBasedata )
    , msg
    , ( env, False )
    )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        KeyDown key ->
            if key == 13 then
                if data.curDialogue.state == IsSpeaking then
                    let
                        curDia =
                            data.curDialogue

                        newDia =
                            { curDia | state = Disappear }
                    in
                    ( ( { data | curDialogue = newDia }, basedata )
                    , []
                    , ( env, False )
                    )

                else
                    ( ( data, basedata ), [], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        Tick _ ->
            let
                curDia =
                    data.curDialogue

                newDia =
                    case curDia.state of
                        Appear ->
                            if curDia.alpha + 0.04 < 1 then
                                { curDia | alpha = curDia.alpha + 0.04 }

                            else
                                { curDia | alpha = 1, state = IsSpeaking }

                        Disappear ->
                            if curDia.alpha - 0.04 > 0 then
                                { curDia | alpha = curDia.alpha - 0.04 }

                            else
                                { curDia | alpha = 0, state = NoDialogue }

                        _ ->
                            curDia
            in
            if curDia /= newDia then
                if newDia.state == NoDialogue then
                    updateHelper env evnt data basedata

                else
                    ( ( { data | curDialogue = newDia }, basedata ), [], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        BeginPlot id ->
            let
                nextDialogue =
                    Maybe.withDefault defaultDialogue <|
                        List.head <|
                            List.filter (\dia -> dia.id == ( id, 1 )) data.remainDiaList

                remainingDialogues =
                    List.filter (\dia -> dia.id /= ( id, 1 )) data.remainDiaList
            in
            if nextDialogue.speaker /= "" then
                ( ( { data
                        | curDialogue = { nextDialogue | state = Appear }
                        , remainDiaList = remainingDialogues
                    }
                  , { basedata | isPlaying = True }
                  )
                , [ Other ( "Trigger", BeginPlot 3 ) ]
                , env
                )

            else
                ( ( data, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


contentToView : ( Int, String ) -> Messenger.Base.Env SceneCommonData UserData -> Data -> Canvas.Renderable
contentToView ( index, text ) env data =
    let
        lineHeight =
            60
    in
    Canvas.group []
        [ renderTextWithColorStyle
            env.globalData.internalData
            40
            text
            data.curDialogue.font
            (Color.rgb255 207 207 207)
            ""
            ( Tuple.first data.curDialogue.textPos
            , toFloat index * lineHeight + Tuple.second data.curDialogue.textPos
            )
        ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.curDialogue.state /= NoDialogue then
        let
            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data) (List.indexedMap Tuple.pair data.curDialogue.content)
        in
        ( Canvas.group [ alpha data.curDialogue.alpha ]
            ([ renderSprite env.globalData.internalData [] data.curDialogue.framePos ( 1880, 400 ) data.curDialogue.frameName
             , renderSprite env.globalData.internalData [] data.curDialogue.speakerPos ( 346, 0 ) data.curDialogue.speaker
             ]
                ++ renderableTexts
            )
        , 3
        )

    else
        ( Canvas.empty, 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Dialogue"


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Component generator
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
