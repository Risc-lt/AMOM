module Scenes.After1.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


cheer : Dialogue
cheer =
    let
        content =
            [ "Wenderd:"
            , "Phew... It's finally over."
            ]
    in
    genDialogue "head_wenderd" content ( 2, 1 )


plaint : Dialogue
plaint =
    let
        content =
            [ "Bithif:"
            , "Over..."
            ]
    in
    genDialogue "head_bithif" content ( 2, 2 )


fear : Dialogue
fear =
    let
        content =
            [ "Wenderd:"
            , "I almost thought I was doomed."
            , "There were so many wolves in this pack."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 1 )


agree : Dialogue
agree =
    let
        content =
            [ "Bruce:"
            , "You know this is our first commission."
            , "We need to do more preparation next time."
            ]
    in
    genDialogue "head_bruce" content ( 4, 2 )


checkWolf : Dialogue
checkWolf =
    let
        content =
            [ "Wenderd:"
            , "Look at their fur, they should be worth a lot of money if sold."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 3 )


remind : Dialogue
remind =
    let
        content =
            [ "Bulingze:"
            , "Let go of that idea. All these furs must be handed over to the"
            , "guild to prove our work results."
            ]
    in
    genDialogue "head_bulingze" content ( 4, 4 )


explain : Dialogue
explain =
    let
        content =
            [ "Wenderd:"
            , "Okay, okay, I get it. You know, I'm just drooling over them."
            , "Those people are just too greedy."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 5 )


silence : Dialogue
silence =
    let
        content =
            [ "Wenderd:"
            , "Well..."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 6 )


recall : Dialogue
recall =
    let
        content =
            [ "Wenderd:"
            , "Guess what, I kind of miss the barbecues we had in the woods"
            , "before we came here."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 7 )


sad : Dialogue
sad =
    let
        content =
            [ "Bithif:"
            , "..."
            ]
    in
    genDialogue "head_bithif" content ( 4, 8 )


refuse : Dialogue
refuse =
    let
        content =
            [ "Bruce:"
            , "...We can't. Not until my research is complete."
            ]
    in
    genDialogue "head_bruce" content ( 4, 9 )


end : Dialogue
end =
    let
        content =
            [ "Wenderd:"
            , "I know, I know, so let's get this over with and get back."
            ]
    in
    genDialogue "head_wenderd" content ( 4, 10 )


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
