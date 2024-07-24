module Scenes.Game.Components.Dialogue.Init exposing (..)


type alias InitData =
    { curDialogue : Dialogue
    , remainDiaList : List Dialogue
    }


type alias Dialogue =
    { frameName : String
    , framePos : ( Float, Float )
    , speaker : String
    , speakerPos : ( Float, Float )
    , font : String
    , isSpeaking : Bool
    , content : List String
    , textPos : ( Float, Float )
    }


emptyInitData : InitData
emptyInitData =
    { curDialogue =
        { frameName = "dialogue_frame"
        , framePos = ( 0, 500 )
        , speaker = "head_magic"
        , speakerPos = ( -20, 680 )
        , font = "Comic Sans MS"
        , isSpeaking = False
        , content = [ "Hello!", "Thank you!" ]
        , textPos = ( 880, 800 )
        }
    , remainDiaList = []
    }
