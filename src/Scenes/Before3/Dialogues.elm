module Scenes.Before3.Dialogues exposing (discribe, thank, ask, explain, interrupt, query, decline, complain, confused, remind, genDialogue, dialogueInitData)

{-|


# Before3 Dialogues module

This module contains all dialogue data for Before3 scene

@docs discribe, thank, ask, explain, interrupt, query, decline, complain, confused, remind, genDialogue, dialogueInitData

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


confused : Dialogue
confused =
    let
        content =
            [ "Bruce:"
            , "Wait, this is the territory of the Magic Towers anyway."
            , "Why would these people chase us here?"
            ]
    in
    genDialogue "head_bruce" content ( 16, 4 )


remind : Dialogue
remind =
    let
        content =
            [ "Wenderd:"
            , "Anyway, get ready for the battle."
            , "They have plenty of people, so be careful."
            ]
    in
    genDialogue "head_wenderd" content ( 16, 5 )


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
        [ discribe
        , thank
        , ask
        , explain
        , interrupt
        , query
        , decline
        , complain
        , confused
        , remind
        ]
    }
