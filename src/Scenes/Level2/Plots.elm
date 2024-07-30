module Scenes.Level2.Plots exposing (..)

{-
   All plot data
-}

import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue, defaultDialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..))


amaze : Dialogue
amaze =
    let
        content =
            [ "Wenderd:"
            , "Damn, this guy is so strong."
            ]
    in
    genDialogue "head_wenderd" content ( 1, 1 )


appreciate : Dialogue
appreciate =
    let
        content =
            [ "Concert:"
            , "You guys are not bad either."
            ]
    in
    genDialogue "head_concert" content ( 1, 2 )


plaint : Dialogue
plaint =
    let
        content =
            [ "Concert:"
            , "I think I've heard of you guys, 'Nightfall Knights'." 
            , "I didn't expect we'd actually fight each other."
            ]
    in
    genDialogue "head_concert" content ( 1, 3 )





bad : Dialogue
bad =
    let
        content =
            [ "Wenderd:"
            , "Hmm... So bad now."
            ]
    in
    genDialogue "head_wenderd" content ( 2, 1 )


worry : Dialogue
worry =
    let
        content =
            [ "Bruce:"
            , "Wenderd! Are you all right?"
            ]
    in
    genDialogue "head_bruce" content ( 2, 2 )


confused : Dialogue
confused =
    let
        content =
            [ "Concert:"
            , "I think I've heard of you guys, 'Nightfall Knights'." 
            , "I didn't expect we'd actually fight each other."
            ]
    in
    genDialogue "head_concert" content ( 2, 2 )


genDialogue : String -> List String -> ( Int, Int ) -> Dialogue
genDialogue speaker content id =
    { defaultDialogue
        | speaker = speaker
        , content = content
        , id = id
    }


dialogueInitData : { curDialogue : Dialogue, remainDiaList : List Dialogue }
dialogueInitData =
    { curDialogue = defaultDialogue
    , remainDiaList =
        [
        ]
    }


triggerInitData : List ( TriggerConditions, Int )
triggerInitData =
    [ 
    ]
