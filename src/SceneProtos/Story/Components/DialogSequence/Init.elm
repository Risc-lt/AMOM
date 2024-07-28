module SceneProtos.Story.Components.DialogSequence.Init exposing (..)

{-|


# Init module

@docs InitData

-}

{- The data sturcture for dialogues -}


type alias Dialogue =
    { frameName : String
    , framePos : ( Float, Float )
    , speaker : String
    , speakerPos : ( Float, Float )
    , font : String
    , isSpeaking : Bool
    , content : List String
    , textPos : ( Float, Float )
    , id : ( Int, Int )
    , timer : Int
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    { curDialogue : Dialogue
    , remainDiaList : List Dialogue
    }


defaultDialogue : Dialogue
defaultDialogue =
    { frameName = "dialogue_frame"
    , framePos = ( 20, 660 )
    , speaker = ""
    , speakerPos = ( 38, 681 )
    , font = "Comic Sans MS"
    , isSpeaking = False
    , content = []
    , textPos = ( 415, 700 )
    , id = ( 0, 0 )
    , timer = 0
    }
