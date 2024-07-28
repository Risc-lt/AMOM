module SceneProtos.Story.Components.DialogSequence.Model exposing (component)

{-| Component model

@docs component

-}

import Bitwise exposing (or)
import Canvas
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (GlobalData, UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (InitData, defaultDialogue)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (DialogueState(..))


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


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        KeyDown key ->
            if key == 13 then
                let
                    curDia =
                        data.curDialogue

                    maybeNextDia =
                        List.head <|
                            List.filter
                                (\dia ->
                                    dia.id == ( Tuple.first curDia.id, Tuple.second curDia.id + 1 )
                                )
                                data.remainDiaList

                    ( nextDia, newBasedata, msg ) =
                        case maybeNextDia of
                            Just dia ->
                                ( { dia | isSpeaking = True }, basedata, [] )

                            _ ->
                                ( { curDia | isSpeaking = False }
                                , { basedata | isPlaying = False }
                                , [ Other ( "Trigger", PlotDone 3 ) ] 
                                )

                    remainingDialogues =
                        List.filter
                            (\dia ->
                                dia.id /= ( Tuple.first curDia.id, Tuple.second curDia.id + 1 )
                            )
                            data.remainDiaList
                in
                ( ( { data | curDialogue = nextDia, remainDiaList = remainingDialogues }, newBasedata )
                , msg
                , ( env, False )
                )

            else
                ( ( data, basedata ), [], ( env, False ) )

        Tick _ ->
            let
                curDia = 
                    data.curDialogue

                newData =
                    case data.curDialogue.state of
                        Appear ->
                            if data.curDialogue.alpha + 0.1 < 1 then
                                { data | curDialogue = { curDia |  }
            in
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
                        | curDialogue = { nextDialogue | isSpeaking = True }
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
    if data.curDialogue.isSpeaking then
        let
            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data) (List.indexedMap Tuple.pair data.curDialogue.content)
        in
        ( Canvas.group []
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
