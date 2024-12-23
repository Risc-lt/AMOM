module Scenes.Before2.Dialogues exposing (dialogueInitData)

{-|


# Before2 Dialogues module

This module contains all dialogue data for Before2 scene

@docs dialogueInitData

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


see : Dialogue
see =
    let
        content =
            [ "Concert:"
            , "Look guys, let me guess what you're looking for."
            , "Ah..."
            ]
    in
    genDialogue "head_concert" content ( 17, 1 )


guess : Dialogue
guess =
    let
        content =
            [ "Concert:"
            , "You are mercenaries, right?"
            , "It seems that I am your target tonight."
            ]
    in
    genDialogue "head_concert" content ( 17, 2 )


care : Dialogue
care =
    let
        content =
            [ "Wenderd:"
            , "Be careful, this guy looks tough."
            ]
    in
    genDialogue "head_wenderd" content ( 17, 3 )


genDialogue : String -> List String -> ( Int, Int ) -> Dialogue
genDialogue speaker content id =
    { defaultDialogue
        | speaker = speaker
        , content = content
        , id = id
    }


{-| Dialogue: Init data
-}
dialogueInitData : InitData
dialogueInitData =
    { curDialogue = defaultDialogue
    , remainDiaList =
        [ feel
        , ask
        , agree
        , decline
        , remind
        , charge
        , see
        , guess
        , care
        ]
    }
