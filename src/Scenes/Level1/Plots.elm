module Scenes.Level1.Plots exposing (..)


{-
   All plot data
-}


import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..), HealthStatus(..))
import SceneProtos.Game.Components.Dialogue.Init exposing (defaultDialogue)


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
    , remainDiaList = []
    }
