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
