module Scenes.Level3.Plots exposing (ask, threaten, silence, decline, remind, complain, prepare, panic, success, dialogueInitData, askTrigger, complainTrigger, successTrigger, dieTrigger, triggerInitData)

{-|


# Plots module

This module contains the plot data for the Level3 scene.

@docs ask, threaten, silence, decline, remind, complain, prepare, panic, success, dialogueInitData, askTrigger, complainTrigger, successTrigger, dieTrigger, triggerInitData

-}

import SceneProtos.Game.Components.ComponentBase exposing (ComponentMsg(..), Gamestate(..))
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
    genDialogue "head_magicorg" content ( 1, 1 )


threaten : Dialogue
threaten =
    let
        content =
            [ "White Robe Man:"
            , "To be honest, there is also Boer's intention"
            , "behind our actions."
            ]
    in
    genDialogue "head_magicorg" content ( 1, 2 )


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


complain : Dialogue
complain =
    let
        content =
            [ "Wenderd:"
            , "Damn, there are too many enemies. There is"
            , "no way to break through."
            ]
    in
    genDialogue "head_wenderd" content ( 102, 1 )


prepare : Dialogue
prepare =
    let
        content =
            [ "Cavalry:"
            , "There is only one way! Give me some more time!"
            ]
    in
    genDialogue "head_cavalry" content ( 102, 2 )


panic : Dialogue
panic =
    let
        content =
            [ "White Robe Man:"
            , "Catch her! She's trying to use teleportation"
            , "magic to escape!"
            ]
    in
    genDialogue "head_magicorg" content ( 102, 3 )


success : Dialogue
success =
    let
        content =
            [ "Cavalry:"
            , "Ok! Success!"
            ]
    in
    genDialogue "head_cavalry" content ( 103, 1 )


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
        [ ask
        , threaten
        , silence
        , decline
        , complain
        , prepare
        , panic
        , success
        ]
    }


askTrigger : ( TriggerConditions, Int )
askTrigger =
    ( StateTrigger "GameBegin", 1 )


complainTrigger : ( TriggerConditions, Int )
complainTrigger =
    ( FrameTrigger 30, 102 )


successTrigger : ( TriggerConditions, Int )
successTrigger =
    ( FrameTrigger 50, 103 )


dieTrigger : ( TriggerConditions, Int )
dieTrigger =
    ( DieTrigger, 101 )


triggerInitData : List ( TriggerConditions, Int )
triggerInitData =
    [ askTrigger
    , complainTrigger
    , successTrigger
    , dieTrigger
    ]
