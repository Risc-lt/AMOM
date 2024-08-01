module SceneProtos.Game.Components.Dialogue.Init exposing
    ( InitData
    , Dialogue
    , emptyInitData
    , defaultDialogue
    )

{-|


# Init module

@docs InitData
@docs Dialogue
@docs emptyInitData
@docs defaultDialogue

-}


{-| Init data for the dialogue
-}
type alias InitData =
    { curDialogue : Dialogue
    , remainDiaList : List Dialogue
    }


{-| Core data structure for the dialogue
-}
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
    }


{-| Default init data for the dialogue
-}
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
        , id = ( 0, 0 )
        }
    , remainDiaList =
        [ { frameName = "dialogue_frame"
          , framePos = ( 0, 500 )
          , speaker = "head_magic"
          , speakerPos = ( -20, 680 )
          , font = "Comic Sans MS"
          , isSpeaking = False
          , content = [ "Hello!", "Thank you!" ]
          , textPos = ( 880, 800 )
          , id = ( 101, 0 )
          }
        ]
    }


{-| Default dialogue
-}
defaultDialogue : Dialogue
defaultDialogue =
    { frameName = "dialogue_frame"
    , framePos = ( 5, 700 )
    , speaker = ""
    , speakerPos = ( 18, 720 )
    , font = "Comic Sans MS"
    , isSpeaking = False
    , content = []
    , textPos = ( 380, 740 )
    , id = ( 0, 0 )
    }
