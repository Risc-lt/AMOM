module Scenes.After2.Dialogues exposing (amaze, affirm, groan, surprise, complain, sad, ask, silence1, confused, hungry, prevent, apologize, comfort, collapse, persuade, hesitate, repeat, astounded, silence2, end, dialogueInitData)

{-|


# Dialogue module

@docs amaze, affirm, groan, surprise, complain, sad, ask, silence1, confused, hungry, prevent, apologize, comfort, collapse, persuade, hesitate, repeat, astounded, silence2, end, dialogueInitData

-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


{-| Dialogue: Amaze
-}
amaze : Dialogue
amaze =
    let
        content =
            [ "Bithif:"
            , "...Is he dead?"
            ]
    in
    genDialogue "head_bithif" content ( 1, 1 )


{-| Dialogue: Affirm
-}
affirm : Dialogue
affirm =
    let
        content =
            [ "Bulingze:"
            , "It seems to be so."
            ]
    in
    genDialogue "head_bulingze" content ( 1, 2 )


{-| Dialogue: Groan
-}
groan : Dialogue
groan =
    let
        content =
            [ "Concert:"
            , "Hmm... so sad..."
            ]
    in
    genDialogue "head_concert" content ( 1, 3 )


{-| Dialogue: Surprise
-}
surprise : Dialogue
surprise =
    let
        content =
            [ "Wenderd:"
            , "!!!"
            ]
    in
    genDialogue "head_wenderd" content ( 1, 4 )


{-| Dialogue: Complain
-}
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


{-| Dialogue: Sad
-}
sad : Dialogue
sad =
    let
        content =
            [ "Bithif:"
            , "..."
            ]
    in
    genDialogue "head_bithif" content ( 1, 6 )


{-| Dialogue: Ask
-}
ask : Dialogue
ask =
    let
        content =
            [ "Bulingze:"
            , "Is he dead now?"
            ]
    in
    genDialogue "head_bulingze" content ( 3, 1 )


{-| Dialogue: Silence
-}
silence1 : Dialogue
silence1 =
    let
        content =
            [ "Wenderd:"
            , "..."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 2 )


{-| Dialogue: Confused
-}
confused : Dialogue
confused =
    let
        content =
            [ "Bulingze:"
            , "Wenderd?"
            ]
    in
    genDialogue "head_bulingze" content ( 3, 3 )


{-| Dialogue: Hungry
-}
hungry : Dialogue
hungry =
    let
        content =
            [ "Wenderd:"
            , "Blood... Smells good..."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 4 )


{-| Dialogue: Prevent
-}
prevent : Dialogue
prevent =
    let
        content =
            [ "Bruce:"
            , "Don't! Wenderd!"
            ]
    in
    genDialogue "head_bruce" content ( 3, 5 )


{-| Dialogue: Apologize
-}
apologize : Dialogue
apologize =
    let
        content =
            [ "Bruce:"
            , "Sorry..."
            ]
    in
    genDialogue "head_bruce" content ( 5, 1 )


{-| Dialogue: Comfort
-}
comfort : Dialogue
comfort =
    let
        content =
            [ "Bulingze:"
            , "It's not your fault, Bruce."
            ]
    in
    genDialogue "head_bulingze" content ( 7, 1 )


{-| Dialogue: Collapse
-}
collapse : Dialogue
collapse =
    let
        content =
            [ "Bithif:"
            , "So is it ours?"
            ]
    in
    genDialogue "head_bithif" content ( 7, 2 )


{-| Dialogue: Persuade
-}
persuade : Dialogue
persuade =
    let
        content =
            [ "Bulingze:"
            , "...Don't talk about that. Let's go back."
            ]
    in
    genDialogue "head_bulingze" content ( 7, 3 )


{-| Dialogue: Hesitate
-}
hesitate : Dialogue
hesitate =
    let
        content =
            [ "Bruce:"
            , "...We need his head."
            ]
    in
    genDialogue "head_bruce" content ( 7, 4 )


{-| Dialogue: Repeat
-}
repeat : Dialogue
repeat =
    let
        content =
            [ "Bruce:"
            , "We need his head to prove our work."
            ]
    in
    genDialogue "head_bruce" content ( 7, 5 )


{-| Dialogue: Astounded
-}
astounded : Dialogue
astounded =
    let
        content =
            [ "Bithif:"
            , "Bruce..."
            ]
    in
    genDialogue "head_bithif" content ( 7, 6 )


{-| Dialogue: Silence
-}
silence2 : Dialogue
silence2 =
    let
        content =
            [ "Bulingze:"
            , "..."
            ]
    in
    genDialogue "head_bulingze" content ( 7, 7 )


{-| Dialogue: End
-}
end : Dialogue
end =
    let
        content =
            [ "Bulingze:"
            , "Okay, let's get this over with quickly."
            ]
    in
    genDialogue "head_bulingze" content ( 9, 1 )


{-| Generate a dialogue
-}
genDialogue : String -> List String -> ( Int, Int ) -> Dialogue
genDialogue speaker content id =
    { defaultDialogue
        | speaker = speaker
        , content = content
        , id = id
    }


{-| The initial data for the dialogues
-}
dialogueInitData : InitData
dialogueInitData =
    let
        list1 =
            [ amaze, affirm, groan, surprise, complain, ask, silence1, confused, hungry ]

        list2 =
            [ prevent, apologize, comfort, collapse, sad, persuade, hesitate, repeat, astounded, silence2, end ]
    in
    { curDialogue = defaultDialogue, remainDiaList = list1 ++ list2 }
