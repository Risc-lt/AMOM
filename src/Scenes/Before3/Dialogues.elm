module Scenes.Before3.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


discribe : Dialogue
discribe =
    let
        content =
            [ "Wenderd:"
            , "Once you pass through this forest, you will enter the border"
            , "of Cins. We will escort you to the nearest city. You'll be safe"
            , "there."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 1 )


thank : Dialogue
thank =
    let
        content =
            [ "Cavalry:"
            , "OK, thank you. I'll pay you the rest then."
            ]
    in
    genDialogue "head_cavalry" content ( 5, 2 )


ask : Dialogue
ask =
    let
        content =
            [ "Wenderd:"
            , "By the way, you still can't tell us your identity?"
            , "Why are you being hunted by the Mainland Magic Association?"
            ]
    in
    genDialogue "head_wenderd" content ( 5, 3 )


explain : Dialogue
explain =
    let
        content =
            [ "Cavalry:"
            , "I'm..."
            ]
    in
    genDialogue "head_cavalry" content ( 5, 4 )


interrupt : Dialogue
interrupt =
    let
        content =
            [ "White Robe Man:"
            , "It doesn't matter who she is to you."
            , "Just send her here and you can leave safely."
            ]
    in
    genDialogue "head_magicorg" content ( 14, 1 )


query : Dialogue
query =
    let
        content =
            [ "Wenderd:"
            , "People from the Mainland Magic Association just interrupt"
            , "others casually?" 
            ]
    in
    genDialogue "head_wenderd" content ( 16, 1 )


decline : Dialogue
decline =
    let
        content =
            [ "Wenderd:"
            , "I will not hand over such a beautiful lady to such rude"
            , "people like you."
            ]
    in
    genDialogue "head_wenderd" content ( 16, 2 )


complain : Dialogue
complain =
    let
        content =
            [ "Bulingze:"
            , "It's good for you to be less glib, Wenderd."
            ]
    in
    genDialogue "head_bulingze" content ( 16, 3 )

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
