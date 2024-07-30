module Scenes.After3.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


remind : Dialogue
remind =
    let
        content =
            [ "Cavalry:"
            , "OK, thank you. I'll pay you the rest then."
            ]
    in
    genDialogue "head_cavalry" content ( 1, 1 )


genDialogue : String -> List String -> ( Int, Int ) -> Dialogue
genDialogue speaker content id =
    { defaultDialogue
        | speaker = speaker
        , content = content
        , id = id
    }


dialogueInitData : InitData
dialogueInitData =
    { curDialogue = defaultDialogue
    , remainDiaList = []
    }
