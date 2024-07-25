module Scenes.Level1.Plots exposing (..)


{-
   All plot data
-}


import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..), HealthStatus(..))
import SceneProtos.Game.Components.Dialogue.Init exposing (defaultDialogue)


startDialogue : Dialogue
startDialogue =
    let
        content =
            [ "Are you all ready to fight?"
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
