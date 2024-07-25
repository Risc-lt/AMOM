module Scenes.Level1.Plots exposing (..)

{-
   All plot data
-}

import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue, defaultDialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (HealthStatus(..), TriggerConditions(..))


startDialogue : Dialogue
startDialogue =
    let
        content =
            [ "Bulingze:"
            , "Are you all ready to fight?"
            , "Press Enter to proceed to the next dialog"
            ]
    in
    genDialogue "head_magic" content ( 1, 1 )


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
        [ startDialogue
        ]
    }


startTrigger : ( TriggerConditions, Int )
startTrigger =
    ( StateTrigger "GameBegin", 1 )


triggerInitData : List ( TriggerConditions, Int )
triggerInitData =
    [ startTrigger
    ]
