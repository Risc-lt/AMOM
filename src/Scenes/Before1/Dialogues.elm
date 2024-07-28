module Scenes.Before1.Dialogues exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


alert : Dialogue
alert =
    let
        content =
            [ "Wenderd:"
            , "Stay alert and pay attention to your surroundings."
            ]
    in
    genDialogue "head_wenderd" content ( 9, 1 )


reply : Dialogue
reply =
    let
        content =
            [ "Bulingze:"
            , "Clear."
            ]
    in
    genDialogue "head_bulingze" content ( 9, 2 )


find : Dialogue
find =
    let
        content =
            [ "Bruce:"
            , "There seems to be some movement... Look!"
            ]
    in
    genDialogue "head_bruce" content ( 9, 3 )


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
        [ alert
        , reply
        , find
        ]
    }
