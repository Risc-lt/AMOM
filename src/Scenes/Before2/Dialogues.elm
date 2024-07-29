module Scenes.Before2.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


feel : Dialogue
feel =
    let
        content =
            [ "Wenderd:"
            , "Gulp..."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 1 )


ask : Dialogue
ask =
    let
        content =
            [ "Bruce:"
            , "Are you okay? We can retreat, you know."
            ]
    in
    genDialogue "head_bruce" content ( 3, 2 )


agree : Dialogue
agree =
    let
        content =
            [ "Bulingze:"
            , "Yeah, this isn't a good place to 'eat'."
            ]
    in
    genDialogue "head_bulingze" content ( 3, 3 )


decline : Dialogue
decline =
    let
        content =
            [ "Wenderd:"
            , "It's okay, I can handle it. This is our biggest deal yet."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 4 ) 


remind : Dialogue
remind =
    let
        content =
            [ "Bruce:"
            , "That's why we need to be more careful... Look!"
            ]
    in
    genDialogue "head_bruce" content ( 3, 5 )


charge : Dialogue
charge =
    let
        content =
            [ "Wenderd:"
            , "Okay, that looks like the target we're looking for."
            , "Let's go!"
            ]
    in
    genDialogue "head_wenderd" content ( 7, 1 ) 


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
        []
    }
