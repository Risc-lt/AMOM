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
        ]
    }
