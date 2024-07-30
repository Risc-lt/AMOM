module Scenes.Level3.Plots exposing (..)
{-
   All plot data
-}

import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue, defaultDialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..))


ask : Dialogue
ask =
    let
        content =
            [ "White Robe Man:"
            , "Think carefully, do you really want to go"
            , "against the Mainland Magic Association?"
            ]
    in
    genDialogue "head_wenderd" content ( 1, 1 )


threaten : Dialogue
threaten =
    let
        content =
            [ "White Robe Man:"
            , "To be honest, there is also Boer's intention"
            , "behind our actions."
            ]
    in
    genDialogue "head_wenderd" content ( 1, 2 )


silence : Dialogue
silence =
    let
        content =
            [ "Cavalry:"
            , "..."
            ]
    in
    genDialogue "head_cavalry" content ( 1, 3 )


decline : Dialogue
decline =
    let
        content =
            [ "Wenderd:"
            , "So what? What do you think we are? Mercenaries"
            , "are just desperate people who do things for money."
            ]
    in
    genDialogue "head_wenderd" content ( 1, 4 )


remind : Dialogue
remind =
    let
        content =
            [ "Wenderd:"
            , "Bithif, note that although poison restores"
            , "health for us, it does the opposite for Cavalry."
            , "She should use restoration potions."
            ]
    in
    genDialogue "head_wenderd" content ( 1, 5 )


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
