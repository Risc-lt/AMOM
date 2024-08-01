module Scenes.Before1.Dialogues exposing (alert, reply, find, prepare, dialogueInitData)

{-|


# Before1 Dialogues module

This module contains all dialogue data for Before1 scene

@docs alert, reply, find, prepare, dialogueInitData

-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


{-| Dialogue: Alert
-}
alert : Dialogue
alert =
    let
        content =
            [ "Wenderd:"
            , "Stay alert and pay attention to your surroundings."
            ]
    in
    genDialogue "head_wenderd" content ( 9, 1 )


{-| Dialogue: Reply
-}
reply : Dialogue
reply =
    let
        content =
            [ "Bulingze:"
            , "Clear."
            ]
    in
    genDialogue "head_bulingze" content ( 9, 2 )


{-| Dialogue: Find
-}
find : Dialogue
find =
    let
        content =
            [ "Bruce:"
            , "There seems to be some movement... Look!"
            ]
    in
    genDialogue "head_bruce" content ( 9, 3 )


{-| Dialogue: Prepare
-}
prepare : Dialogue
prepare =
    let
        content =
            [ "Wenderd:"
            , "Be careful everyone, prepare to fight!"
            ]
    in
    genDialogue "head_wenderd" content ( 14, 1 )


{-| Generate a dialogue
-}
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
        [ alert
        , reply
        , find
        , prepare
        ]
    }
