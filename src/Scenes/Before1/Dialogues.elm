module Scenes.Before1.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


start : Dialogue
start =
    let
        content =
            [ "Wenderd:"
            , "Stay alert and pay attention to your surroundings."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 1 )


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
        [ start
        ]
    }
