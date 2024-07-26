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


type alias Data =
    


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        NewDialogSequenceMsg deliver ->
            ( { frameName = "dialogue_frame"
              , framePos = ( 720, 0 )
              , speaker = deliver.speaker
              , speakerPos = ( 720, 0 )
              , font = "Comic Sans MS"
              , isSpeaking = True
              , content = deliver.content
              , textPos = ( 720, 1320 )
              , nextTar = deliver.nextTar
              , next = deliver.next
              , timer = 0
              }
            , ()
            )

        _ ->
            ( { frameName = "dialogue_frame"
              , framePos = ( 720, 0 )
              , speaker = "Bithif"
              , speakerPos = ( 720, 0 )
              , font = "Comic Sans MS"
              , isSpeaking = False
              , content = [ "What can I say, Man!" ]
              , textPos = ( 720, 1320 )
              , nextTar = [ " " ]
              , next = [ NullComponentMsg ]
              , timer = 0
              }
            , ()
            )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick dt ->
            let
                newTimer =
                    data.timer + dt

                newMsg =
                    List.head data.next

                notOver =
                    isNotOver data.timer 2000

                newTar =
                    data.nextTar

                msgList =
                    Debug.log "DiaMsgList(Update)" List.map2 Tuple.pair newTar data.next

                sendMsg =
                    if newMsg == Just NullComponentMsg then
                        ( ( { data | timer = 0 }, basedata ), [], ( env, False ) )

                    else
                        ( ( { data | timer = 0, isSpeaking = True }, basedata ), List.map (\item -> Other item) msgList, ( env, False ) )

                -- isSpeaking -> False
                -- _ =
                --      msgList
                --( ( { data | timer = 0, isSpeaking = False }, basedata ), [  ], ( env, False ) )
            in
            if notOver then
                ( ( { data | timer = newTimer }, basedata ), [], ( env, False ) )

            else
                sendMsg

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


isNotOver : Int -> Int -> Bool
isNotOver timer terminal =
    if timer <= terminal then
        True

    else
        False


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        NewDialogSequenceMsg deliver ->
            let
                newDeliver =
                    deliver

                _ =
                    Debug.log "DiaRecMsg" newDeliver
            in
            ( ( { frameName = "dialogue_frame"
                , framePos = ( 720, 0 )
                , speaker = deliver.speaker
                , speakerPos = ( 720, 0 )
                , font = "Comic Sans MS"
                , isSpeaking = True
                , content = deliver.content
                , textPos = ( 720, 1320 )
                , nextTar = deliver.nextTar
                , next = deliver.next
                , timer = 0
                }
              , ()
              )
            , []
            , env
            )

        _ ->
            ( ( { frameName = "dialogue_frame"
                , framePos = ( 720, 0 )
                , speaker = "Bithif"
                , speakerPos = ( 720, 0 )
                , font = "Comic Sans MS"
                , isSpeaking = False
                , content = [ "What can I say, Man!" ]
                , textPos = ( 720, 1320 )
                , nextTar = [ " " ]
                , next = [ NullComponentMsg ]
                , timer = 0
                }
              , ()
              )
            , []
            , env
            )



-- case msg of
--     NewDialogSequenceMsg newDialogue ->
--         let
--             newSpeaker =
--                 newDialogue.speaker
--             newContent =
--                 newDialogue.content
--             state =
--                 True
--         in
--         ( ( { data | speaker = newSpeaker, content = newContent, isSpeaking = state }, basedata ), [], env )
--     NextDialogue newDialogue ->
--         let
--             newSpeaker =
--                 newDialogue.speaker
--             newContent =
--                 newDialogue.content
--             state =
--                 True
--         in
--         ( ( { data | speaker = newSpeaker, content = newContent, isSpeaking = state }, basedata ), [], env )
--     CloseDialogue ->
--         ( ( { data | isSpeaking = False }, basedata ), [], env )
--     _ ->
--        ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.isSpeaking then
        let
            lineHeight =
                30

            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data lineHeight) (List.indexedMap Tuple.pair data.content)

            _ =
                Debug.log "lineHeightView" lineHeight
        in
        ( Canvas.group []
            ([ renderSprite env.globalData.internalData [] data.framePos ( 1980, 0 ) data.frameName
             , renderSprite env.globalData.internalData [] data.speakerPos ( 1980, 0 ) data.speaker

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
        [ renderTextWithColorCenter env.globalData.internalData 60 text data.font Color.black ( Tuple.first data.textPos, toFloat index * lineHeight + Tuple.second data.textPos )
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
