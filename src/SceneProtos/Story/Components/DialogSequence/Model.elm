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
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (InitData)
import SceneProtos.Story.Components.DialogSequence.Init exposing (defaultDialogue)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        DialogueInit deliver ->
            ( deliver, 0 )

        _ ->
            ( { curDialogue = defaultDialogue
              , remainDiaList = []
              }
            , 0
            )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        KeyDown key ->
            if key == 13 then
                let
                    curDia =
                        data.curDialogue
                in
                ( ( { data | curDialogue = { curDia | isSpeaking = False } }, basedata ), [ Other ( "Self", CloseDialogue ), Other ( "Enemy", CloseDialogue ) ], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        BeginDialogue id ->
            let
                nextDialogue =
                    Maybe.withDefault defaultDialogue <|
                        List.head <|
                            List.filter (\dia -> dia.id == id) data.remainDiaList

                remainingDialogues =
                    List.filter (\dia -> dia.id /= id) data.remainDiaList
            in
            ( ( { data
                    | curDialogue = { nextDialogue | isSpeaking = True }
                    , remainDiaList = remainingDialogues
                }
              , basedata
              )
            , [ Other ( "Self", BeginDialogue id )
              , Other ( "Enemy", BeginDialogue id )
              ]
            , env
            )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.curDialogue.isSpeaking then
        let
            lineHeight =
                30

            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data lineHeight) (List.indexedMap Tuple.pair data.curDialogue.content)
        in
        ( Canvas.group []
            ([ renderSprite env.globalData.internalData [] data.curDialogue.framePos ( 1980, 0 ) data.curDialogue.frameName
             , renderSprite env.globalData.internalData [] data.curDialogue.speakerPos ( 1980, 0 ) data.curDialogue.speaker

             --, renderTextWithColorCenter env.globalData.internalData 60 ( data.content data.textPos env) data.font Color.black data.textPos
             ]
                ++ renderableTexts
            )
        , 100
        )
        --z-index

    else
        ( Canvas.empty, 0 )


contentToView : ( Int, String ) -> Messenger.Base.Env SceneCommonData UserData -> Data -> Float -> Canvas.Renderable
contentToView ( index, text ) env data lineHeight =
    Canvas.group []
        [ renderTextWithColorCenter env.globalData.internalData 60 text data.curDialogue.font Color.black ( Tuple.first data.curDialogue.textPos, toFloat index * lineHeight + Tuple.second data.curDialogue.textPos )
        ]


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "DialogSequence"


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
