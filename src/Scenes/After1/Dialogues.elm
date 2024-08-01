module Scenes.After1.Dialogues exposing (agree, checkWolf, cheer, dialogueInitData, end, explain, fear, plaint, recall, refuse, remind, sad, silence)

{-|


# Dialogues module

This module is used to generate the dialogues for the scene.

@docs agree, checkWolf, cheer, dialogueInitData, end, explain, fear, plaint, recall, refuse, remind, sad, silence

-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


{-| Dialogue: Cheer
-}
cheer : Dialogue
cheer =
    let
        content =
            [ "Wenderd:"
            , "Phew... It's finally over."
            ]
    in
    genDialogue "head_wenderd" content ( 2, 1 )


{-| Dialogue: Plaint
-}
plaint : Dialogue
plaint =
    let
        content =
            [ "Bithif:"
            , "Over..."
            ]
    in
    genDialogue "head_bithif" content ( 2, 2 )


{-| Dialogue: Fear
-}
fear : Dialogue
fear =
    let
        content =
            [ "Wenderd:"
            , "I almost thought I was doomed."
            , "There were so many wolves in this pack."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 1 )


{-| Dialogue: Agree
-}
agree : Dialogue
agree =
    let
        content =
            [ "Bruce:"
            , "You know this is our first commission."
            , "We need to do more preparation next time."
            ]
    in
    genDialogue "head_bruce" content ( 5, 2 )


{-| Dialogue: Check the wolf
-}
checkWolf : Dialogue
checkWolf =
    let
        content =
            [ "Wenderd:"
            , "Look at their fur, they should be worth a lot of money if sold."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 3 )


{-| Dialogue: Remind
-}
remind : Dialogue
remind =
    let
        content =
            [ "Bulingze:"
            , "Let go of that idea. All these furs must be handed over to the"
            , "guild to prove our work results."
            ]
    in
    genDialogue "head_bulingze" content ( 5, 4 )


{-| Dialogue: Explain
-}
explain : Dialogue
explain =
    let
        content =
            [ "Wenderd:"
            , "Okay, okay, I get it. You know, I'm just drooling over them."
            , "Those people are just too greedy."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 5 )


{-| Dialogue: Silence
-}
silence : Dialogue
silence =
    let
        content =
            [ "Wenderd:"
            , "Well..."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 6 )


{-| Dialogue: Recall
-}
recall : Dialogue
recall =
    let
        content =
            [ "Wenderd:"
            , "Guess what, I kind of miss the barbecues we had in the woods"
            , "before we came here."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 7 )


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
    genDialogue "head_bithif" content ( 5, 8 )


{-| Dialogue: Refuse
-}
refuse : Dialogue
refuse =
    let
        content =
            [ "Bruce:"
            , "...We can't. Not until my research is complete."
            ]
    in
    genDialogue "head_bruce" content ( 5, 9 )


{-| Dialogue: End
-}
end : Dialogue
end =
    let
        content =
            [ "Wenderd:"
            , "I know, I know, so let's get this over with and get back."
            ]
    in
    genDialogue "head_wenderd" content ( 5, 10 )


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
    { curDialogue = defaultDialogue
    , remainDiaList =
        [ cheer
        , plaint
        , fear
        , agree
        , checkWolf
        , remind
        , explain
        , silence
        , recall
        , sad
        , refuse
        , end
        ]
    }
