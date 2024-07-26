module SceneProtos.Story.Components.ComponentBase exposing 
    (BaseData
    , ComponentMsg(..), ComponentTarget, initBaseData)

import SceneProtos.Story.Components.CharSequence.Init as Character exposing (Character)
import SceneProtos.Story.Components.DialogSequence.Init as Dialogue
import SceneProtos.Story.Components.Background.Init as Background


{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}
type ComponentMsg
    = BeginPlot Int
    | DialogueInit Dialogue.InitData
    | CharInit Character.InitData
    | BackgroundInit Background.InitData
    | ChangeChars (List Character)
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    { curId : Int
    , isPlaying : Bool
    }


initBaseData : BaseData
initBaseData =
    { curId = 0
    , isPlaying = False
    }
