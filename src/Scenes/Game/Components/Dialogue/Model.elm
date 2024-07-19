module Scenes.Game.Components.Dialogue.Model exposing (component)

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
import SceneProtos.Story.Components.Dialogue.Init exposing (CreateInitData)
import Scenes.Game.Components.ComponentBase exposing (ActionMsg(..), BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), InitMsg(..), StatusMsg(..), initBaseData)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    { frameName : String
    , framePos : ( Float, Float )
    , speaker : String
    , speakerPos : ( Float, Float )
    , font : String
    , isSpeaking : Bool
    , content : List String
    , textPos : ( Float, Float )
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    ( { frameName = "dialogue_frame"
      , framePos = ( 0, 500 )
      , speaker = "newhead"
      , speakerPos = ( -20, 680 )
      , font = "Comic Sans MS"
      , isSpeaking = True
      , content = [ "Hello!", "Thank you!" ]
      , textPos = ( 880, 800 )
      }
    , initBaseData
    )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        NewDialogueMsg newDialogue ->
            let
                newSpeaker =
                    newDialogue.speaker

                newContent =
                    newDialogue.content

                state =
                    True
            in
            ( ( { data | speaker = newSpeaker, content = newContent, isSpeaking = state }, basedata ), [], env )

        CloseDialogue ->
            ( ( { data | isSpeaking = False }, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


contentToView : ( Int, String ) -> Messenger.Base.Env SceneCommonData UserData -> Data -> Canvas.Renderable
contentToView ( index, text ) env data =
    let
        lineHeight =
            72
    in
    Canvas.group []
        [ renderTextWithColorCenter env.globalData.internalData 60 text data.font Color.black ( Tuple.first data.textPos, toFloat index * lineHeight + Tuple.second data.textPos )
        ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.isSpeaking then
        let
            renderableTexts =
                List.map (\textWithIndex -> contentToView textWithIndex env data) (List.indexedMap Tuple.pair data.content)
        in
        ( Canvas.group []
            ([ renderSprite env.globalData.internalData [] data.framePos ( 1420, 591 ) data.frameName
             , renderSprite env.globalData.internalData [] data.speakerPos ( 420, 0 ) data.speaker
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
