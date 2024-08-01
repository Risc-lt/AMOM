module Scenes.After2.Dialogues exposing (..)

{-
   All dialogue data
-}

import Json.Decode exposing (list)
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
    genDialogue "head_concert" content ( 1, 3 )


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
    genDialogue "head_concert" content ( 1, 5 )


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
    genDialogue "head_bulingze" content ( 4, 1 )


silence1 : Dialogue
silence1 =
    let
        content =
            [ "Wenderd:"
            , "..."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 2 )


confused : Dialogue
confused =
    let
        content =
            [ "Bulingze:"
            , "Wenderd?"
            ]
    in
    genDialogue "head_bulingze" content ( 4, 3 )


hungry : Dialogue
hungry =
    let
        content =
            [ "Wenderd:"
            , "Blood... Smells good..."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 4 )


prevent : Dialogue
prevent =
    let
        content =
            [ "Bruce:"
            , "Don't! Wenderd!"
            ]
    in
    genDialogue "head_bruce" content ( 4, 5 )


apologize : Dialogue
apologize =
    let
        content =
            [ "Bruce:"
            , "Sorry..."
            ]
    in
    genDialogue "head_bruce" content ( 8, 1 )


comfort : Dialogue
comfort =
    let
        content =
            [ "Bulingze:"
            , "It's not your fault, Bruce."
            ]
    in
    genDialogue "head_bulingze" content ( 10, 1 )


collapse : Dialogue
collapse =
    let
        content =
            [ "Bithif:"
            , "So is it ours?"
            ]
    in
    genDialogue "head_bithif" content ( 10, 2 )


persuade : Dialogue
persuade =
    let
        content =
            [ "Bulingze:"
            , "...Don't talk about that. Let's go back."
            ]
    in
    genDialogue "head_bulingze" content ( 10, 3 )


hesitate : Dialogue
hesitate =
    let
        content =
            [ "Bruce:"
            , "...We need his head."
            ]
    in
    genDialogue "head_bruce" content ( 10, 4 )


repeat : Dialogue
repeat =
    let
        content =
            [ "Bruce:"
            , "We need his head to prove our work."
            ]
    in
    genDialogue "head_bruce" content ( 10, 5 )


astounded : Dialogue
astounded =
    let
        content =
            [ "Bithif:"
            , "Bruce..."
            ]
    in
    genDialogue "head_bithif" content ( 10, 6 )


silence2 : Dialogue
silence2 =
    let
        content =
            [ "Bulingze:"
            , "..."
            ]
    in
    genDialogue "head_bulingze" content ( 10, 7 )


end : Dialogue
end =
    let
        content =
            [ "Bulingze:"
            , "Okay, let's get this over with quickly."
            ]
    in
    genDialogue "head_bulingze" content ( 12, 1 )


genDialogue : String -> List String -> ( Int, Int ) -> Dialogue
genDialogue speaker content id =
    { defaultDialogue
        | speaker = speaker
        , content = content
        , id = id
    }


dialogueInitData : InitData
dialogueInitData =
    let
        list1 =
            [ amaze, affirm, groan, surprise, complain ]

        list2 =
            [ ask, silence1, confused, hungry, prevent, apologize, comfort, collapse ]

        list3 =
            [ sad, persuade, hesitate, repeat, astounded, silence2, end ]
    in
    { curDialogue = defaultDialogue
    , remainDiaList =
        list1 ++ list2 ++ list3
    }
