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
            , "Watch out!"
            ]
    in
    genDialogue "head_cavalry" content ( 1, 1 )


interrupt : Dialogue
interrupt =
    let
        content =
            [ "White Robe Man:"
            , "Damn!"
            ]
    in
    genDialogue "head_magicorg" content ( 1, 2 )


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
        [ remind
        , interrupt
        ]
    }
