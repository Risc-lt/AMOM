module Scenes.After4.Dialogues exposing
    ( affirm
    , confused
    , dialogueInitData
    , silence
    )

import SceneProtos.Story.Components.DialogSequence.Init exposing (Dialogue, InitData, defaultDialogue)


{-| Dialogue: Silence
-}
silence : Dialogue
silence =
    let
        content =
            [ "Bruce:"
            , "...?"
            ]
    in
    genDialogue "head_bruce" content ( 1, 1 )


{-| Dialogue: Confused
-}
confused : Dialogue
confused =
    let
        content =
            [ "Bruce:"
            , "Here it is...?"
            ]
    in
    genDialogue "head_bruce" content ( 1, 2 )


{-| Dialogue: Affirm
-}
affirm : Dialogue
affirm =
    let
        content =
            [ "Bruce:"
            , "Sevast Port?"
            ]
    in
    genDialogue "head_bruce" content ( 1, 3 )


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
        [ silence
        , confused
        , affirm
        ]
    }
