module Scenes.After4.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


silence : Dialogue
silence =
    let
        content =
            [ "Bruce:"
            , "...?"
            ]
    in
    genDialogue "head_bruce" content ( 1, 1 )


confused : Dialogue
confused =
    let
        content =
            [ "Bruce:"
            , "Here it is...?"
            ]
    in
    genDialogue "head_bruce" content ( 1, 2 )


affirm : Dialogue
affirm =
    let
        content =
            [ "Bruce:"
            , "Sevast Port?"
            ]
    in
    genDialogue "head_bruce" content ( 1, 3 )


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
    , remainDiaList =
        [ silence
        , confused
        , affirm
        ]
    }
