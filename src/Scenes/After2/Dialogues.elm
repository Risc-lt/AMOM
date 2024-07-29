module Scenes.After2.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


amaze : Dialogue
amaze =
    let
        content =
            [ "Bithif:"
            , "...Is he dead?"
            ]
    in
    genDialogue "head_bithif" content ( 1, 1 )


affirm : Dialogue
affirm =
    let
        content =
            [ "Bulingze:"
            , "It seems to be so."
            ]
    in
    genDialogue "head_bulingze" content ( 1, 2 )


groan : Dialogue
groan =
    let
        content =
            [ "Concert:"
            , "Hmm... so sad..."
            ]
    in
    genDialogue "head_cavalry" content ( 1, 3 )


surprise : Dialogue
surprise =
    let
        content =
            [ "Wenderd:"
            , "!!!"
            ]
    in
    genDialogue "head_wenderd" content ( 1, 4 )


complain : Dialogue
complain =
    let
        content =
            [ "Concert:"
            , "I couldn't... wait for justice to judge me..."
            , "but lost to you... the most... despicable creatures."
            ]
    in
    genDialogue "head_cavalry" content ( 1, 5 )


sad : Dialogue
sad =
    let
        content =
            [ "Bithif:"
            , "..."
            ]
    in
    genDialogue "head_bithif" content ( 1, 6 )


ask : Dialogue
ask =
    let
        content =
            [ "Bulingze:"
            , "Is he dead now?"
            ]
    in
    genDialogue "head_bulingze" content ( 3, 1 )


silence1 : Dialogue
silence1 =
    let
        content =
            [ "Wenderd:"
            , "..."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 2 )


confused : Dialogue
confused =
    let
        content =
            [ "Bulingze:"
            , "Wenderd?"
            ]
    in
    genDialogue "head_bulingze" content ( 3, 3 )


hungry : Dialogue
hungry =
    let
        content =
            [ "Wenderd:"
            , "Blood... Smells good..."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 4 )


prevent : Dialogue
prevent =
    let
        content =
            [ "Bruce:"
            , "Don't! Wenderd!"
            ]
    in
    genDialogue "head_bruce" content ( 3, 5 )


apologize : Dialogue
apologize =
    let
        content =
            [ "Bruce:"
            , "Sorry..."
            ]
    in
    genDialogue "head_bruce" content ( 5, 1 )


comfort : Dialogue
comfort =
    let
        content =
            [ "Bulingze:"
            , "It's not your fault, Bruce."
            ]
    in
    genDialogue "head_bulingze" content ( 7, 1 )


collapse : Dialogue
collapse =
    let
        content =
            [ "Bithif:"
            , "So is it ours?"
            ]
    in
    genDialogue "head_bithif" content ( 7, 2 )


persuade : Dialogue
persuade =
    let
        content =
            [ "Bulingze:"
            , "...Don't talk about that. Let's go back."
            ]
    in
    genDialogue "head_bulingze" content ( 7, 3 )


hesitate : Dialogue
hesitate =
    let
        content =
            [ "Bruce:"
            , "...We need his head."
            ]
    in
    genDialogue "head_bruce" content ( 7, 4 )


repeat : Dialogue
repeat =
    let
        content =
            [ "Bruce:"
            , "We need his head to prove our work."
            ]
    in
    genDialogue "head_bruce" content ( 7, 5 )


astounded : Dialogue
astounded =
    let
        content =
            [ "Bithif:"
            , "Bruce..."
            ]
    in
    genDialogue "head_bithif" content ( 7, 6 )


silence2 : Dialogue
silence2 =
    let
        content =
            [ "Bulingze:"
            , "..."
            ]
    in
    genDialogue "head_bulingze" content ( 7, 7 )


end : Dialogue
end =
    let
        content =
            [ "Bulingze:"
            , "Okay, let's get this over with quickly."
            ]
    in
    genDialogue "head_bulingze" content ( 9, 1 )


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
        [ amaze
        , affirm
        , groan
        , surprise
        , complain
        , ask
        , silence1
        , confused
        , hungry
        , prevent
        , apologize
        , comfort
        , sad
        , persuade
        , hesitate
        , repeat
        , astounded
        , silence2
        , end
        ]
    }
