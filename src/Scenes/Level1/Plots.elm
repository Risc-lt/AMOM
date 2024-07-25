module Scenes.Level1.Plots exposing (..)

{-
   All plot data
-}

import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue, defaultDialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (HealthStatus(..), TriggerConditions(..))


start : Dialogue
start =
    let
        content =
            [ "Bulingze:"
            , "Are you all ready to fight?"
            , "Press Enter to proceed to the next dialog."
            ]
    in
    genDialogue "head_magic" content ( 1, 1 )


preparation : Dialogue
preparation =
    let
        content =
            [ "Bulingze:"
            , "Start laying out our formation now!"
            , "Press Enter to start the position arrangement,"
            , "and press Enter again if you are done to start"
            , "the battle!"
            ]
    in
    genDialogue "head_magic" content ( 1, 2 )


guidence : Dialogue
guidence =
    let
        content =
            [ "Bulingze:"
            , "Be careful to choose your action and targets!"
            , "Only Bruce's normal attack can reach the back"
            , "row enemies."
            ]
    in
    genDialogue "head_magic" content ( 2, 1 )


skill : Dialogue
skill =
    let
        content =
            [ "Bulingze:"
            , "We need energy to use special skills and magic"
            , "points to use magics."
            , "If you can use skills, don't be stingy!"
            ]
    in
    genDialogue "head_magic" content ( 2, 2 )


item : Dialogue
item =
    let
        content =
            [ "Bulingze:"
            , "Bithif, you have very limited potions, be careful"
            , "when to use them!"
            , "Remember to use poison to restore health and"
            , "magic water to restore magic points."
            ]
    in
    genDialogue "head_magic" content ( 2, 3 )


normalAttack : Dialogue
normalAttack =
    let
        content =
            [ "Bulingze:"
            , "Our normal attacks may be dodged or "
            , "counterattacked."
            , "But if we are lucky enough, we can hit the "
            , "enemy's weak spot and cause more damage."
            , "Magics may be dodged too."
            ]
    in
    genDialogue "head_magic" content ( 3, 1 )


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
        [ start
        , preparation
        , guidence
        , skill
        , item
        , normalAttack
        ]
    }


startTrigger : ( TriggerConditions, Int )
startTrigger =
    ( StateTrigger "GameBegin", 1 )


guidenceTrigger : ( TriggerConditions, Int )
guidenceTrigger =
    ( StateTrigger "PlayerTurn", 2 )


attackTrigger : ( TriggerConditions, Int )
attackTrigger =
    ( FrameTrigger 7, 3 )


triggerInitData : List ( TriggerConditions, Int )
triggerInitData =
    [ startTrigger
    , guidenceTrigger
    , attackTrigger
    ]
