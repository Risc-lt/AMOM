module SceneProtos.Story.Components.DialogSequence.Init exposing
    ( InitData
    , Dialogue, DialogueState(..)
    , defaultDialogue
    )

{-|


# Init module

@docs InitData
@docs Dialogue, DialogueState
@docs defaultDialogue

-}


{-| The data sturcture for dialogues
-}
type DialogueState
    = IsSpeaking
    | Appear
    | Disappear
    | NoDialogue


{-| The data structure for dialogues
-}
type alias Dialogue =
    { frameName : String
    , framePos : ( Float, Float )
    , speaker : String
    , speakerPos : ( Float, Float )
    , font : String
    , state : DialogueState
    , content : List String
    , textPos : ( Float, Float )
    , id : ( Int, Int )
    , alpha : Float
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    { curDialogue : Dialogue
    , remainDiaList : List Dialogue
    }


{-| Default dialogue data
-}
defaultDialogue : Dialogue
defaultDialogue =
    { frameName = "dialogue_frame"
    , framePos = ( 20, 660 )
    , speaker = ""
    , speakerPos = ( 38, 681 )
    , font = "Comic Sans MS"
    , state = NoDialogue
    , content = []
    , textPos = ( 415, 700 )
    , id = ( 0, 0 )
    , alpha = 0
    }
