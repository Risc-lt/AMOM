module SceneProtos.Story.Components.Dialogue.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (GlobalData)
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import Scenes.Game.Components.ComponentBase exposing (InitMsg)


type alias OneDialogue =
    { speaker : String
    , content : List String
    }


type alias CommonElement =
    { frameName : String
    , framePos : ( Float, Float )
    , speakerPos : ( Float, Float )
    , font : String
    , isSpeaking : Bool
    , textPos : ( Float, Float )
    }


type alias Data =
    { thisDialogue : List OneDialogue
    , commonElement : CommonElement
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        NewDialogueMsg initData ->
            let
                initDialogue =
                    initData
                initCommonElement =
                    { frameName = "dialogue_frame"
                    , framePos = ( 720, 0 )
                    , speakerPos = ( 720, 0 )
                    , font = "Comic Sans MS"
                    , isSpeaking = True
                    , textPos = ( 720, 1320 )
                    }
                data = 
                    { thisDialogue = initDialogue
                    , commonElement = initCommonElement }
            in
                ( data, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    ( ( data, basedata ), [], env )

    -- case msg of
    --     NewDialogueMsg newDialogue ->
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
    --         ( ( data, basedata ), [], env )

view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.commonElement.isSpeaking then
        let
            lineHeight =
                30

            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data.commonElement lineHeight) data.thisDialogue--(List.indexedMap Tuple.pair data.thisDialogue)
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


contentToView : ( Int, String ) -> Messenger.Base.Env SceneCommonData UserData -> CommonElement -> Float -> Canvas.Renderable
contentToView ( index, text ) env commonElement lineHeight =
    Canvas.group []
        [ renderTextWithColorCenter env.globalData.internalData 60 text commonElement.font Color.black ( Tuple.first commonElement.textPos, toFloat index * lineHeight + Tuple.second commonElement.textPos )
        ]


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
