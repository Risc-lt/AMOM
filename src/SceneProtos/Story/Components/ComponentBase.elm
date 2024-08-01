module SceneProtos.Story.Components.ComponentBase exposing
    ( ComponentMsg(..), ComponentTarget, BaseData
    , initBaseData
    )

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData
@docs initBaseData

-}

import SceneProtos.Story.Components.Background.Init as Background
import SceneProtos.Story.Components.CharSequence.Init as Character exposing (Character)
import SceneProtos.Story.Components.DialogSequence.Init as Dialogue


{-| Component message
-}
type ComponentMsg
    = BeginPlot Int
    | DialogueInit Dialogue.InitData
    | CharInit Character.InitData
    | BackgroundInit Background.InitData
    | TriggerInit Int
    | EndMove
    | PlotDone Int
    | Over
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
