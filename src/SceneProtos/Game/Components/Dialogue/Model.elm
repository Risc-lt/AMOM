module SceneProtos.Game.Components.Dialogue.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorStyle)
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import SceneProtos.Game.Components.Dialogue.Init exposing (InitData, defaultDialogue, emptyInitData)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (InitDialogueMsg initData) ->
            ( initData, initBaseData )

        _ ->
            ( emptyInitData, initBaseData )


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

                    ( nextDia, msg ) =
                        case maybeNextDia of
                            Just dia ->
                                ( { dia | isSpeaking = True }, [] )

                            _ ->
                                if curDia.id == ( 103, 1 ) then
                                    ( { curDia | isSpeaking = False }
                                    , [ Other ( "Enemy", Defeated True ) ]
                                    )

                                else
                                    ( { curDia | isSpeaking = False }
                                    , [ Other ( "Self", CloseDialogue ), Other ( "Enemy", CloseDialogue ) ]
                                    )

                    remainingDialogues =
                        List.filter
                            (\dia ->
                                dia.id /= ( Tuple.first curDia.id, Tuple.second curDia.id + 1 )
                            )
                            data.remainDiaList
                in
                ( ( { data | curDialogue = nextDia, remainDiaList = remainingDialogues }, basedata )
                , msg
                , ( env, False )
                )

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
                            List.filter (\dia -> dia.id == ( id, 1 )) data.remainDiaList

                otherMsg =
                    case id of
                        101 ->
                            [ Other ( "Enemy", AddChar ) ]

                        102 ->
                            [ Other ( "Self", PutBuff NoAction 100 ) ]

                        _ ->
                            []

                remainingDialogues =
                    List.filter (\dia -> dia.id /= ( id, 1 )) data.remainDiaList
            in
            if nextDialogue.speaker == "" then
                ( ( data, basedata ), otherMsg, env )

            else
                ( ( { data
                        | curDialogue = { nextDialogue | isSpeaking = True }
                        , remainDiaList = remainingDialogues
                    }
                  , basedata
                  )
                , [ Other ( "Self", BeginDialogue id )
                  , Other ( "Enemy", BeginDialogue id )
                  ]
                    ++ otherMsg
                , env
                )

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
            Color.black
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
                List.map
                    (\textWithIndex ->
                        contentToView textWithIndex env data
                    )
                    (List.indexedMap Tuple.pair data.curDialogue.content)

            ( x, y ) =
                data.curDialogue.speakerPos
        in
        ( Canvas.group []
            ([ renderSprite env.globalData.internalData [] data.curDialogue.framePos ( 1430, 385 ) data.curDialogue.frameName
             , renderSprite env.globalData.internalData [] ( x, y ) ( 333, 0 ) data.curDialogue.speaker
             ]
                ++ renderableTexts
            )
        , 100
        )
        --z-index

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
