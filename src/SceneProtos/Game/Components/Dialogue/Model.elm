module SceneProtos.Game.Components.Dialogue.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (GlobalData, UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import SceneProtos.Game.Components.Dialogue.Init exposing (InitData, emptyInitData)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.Dialogue.Init exposing (CreateInitData)


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
                    Maybe.withDefault
                        { frameName = "dialogue_frame"
                        , framePos = ( 0, 500 )
                        , speaker = "head_magic"
                        , speakerPos = ( -20, 680 )
                        , font = "Comic Sans MS"
                        , isSpeaking = False
                        , content = [ "Hello!", "Thank you!" ]
                        , textPos = ( 880, 800 )
                        , id = 0
                        }
                    <|
                        List.head <|
                            List.filter (\dia -> dia.id == id) data.remainDiaList

                otherMsg =
                    case nextDialogue.id of
                        101 ->
                            [ Other ( "Enemy", AddChar ) ]

                        102 ->
                            [ Other ( "Enemy", PutBuff (AttackUp 10) 10 ) ]

                        _ ->
                            []

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
                ++ otherMsg
            , env
            )

        _ ->
            ( ( data, basedata ), [], env )


contentToView : ( Int, String ) -> Messenger.Base.Env SceneCommonData UserData -> Data -> Canvas.Renderable
contentToView ( index, text ) env data =
    let
        lineHeight =
            72
    in
    Canvas.group []
        [ renderTextWithColorCenter env.globalData.internalData 60 text data.curDialogue.font Color.black ( Tuple.first data.curDialogue.textPos, toFloat index * lineHeight + Tuple.second data.curDialogue.textPos )
        ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.curDialogue.isSpeaking then
        let
            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data) (List.indexedMap Tuple.pair data.curDialogue.content)
        in
        ( Canvas.group []
            ([ renderSprite env.globalData.internalData [] data.curDialogue.framePos ( 1420, 591 ) data.curDialogue.frameName
             , renderSprite env.globalData.internalData [] data.curDialogue.speakerPos ( 420, 0 ) data.curDialogue.speaker
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
