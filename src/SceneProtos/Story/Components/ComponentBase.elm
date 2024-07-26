module SceneProtos.Story.Components.ComponentBase exposing 
    (BaseData
    , CharAction(..), ComponentMsg(..), ComponentTarget, initBaseData)

import SceneProtos.Story.Components.Character.Init as Character
import SceneProtos.Story.Components.DialogSequence.Init as Dialogue


{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}
type ComponentMsg
    = BeginPlot Int
    | DialogueInit Dialogue.InitData
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


type CharAction
    = MoveLeft Float
    | MoveUp Float
    | MoveDown Float
    | MoveRight Float
    | Still


type alias Object =
    { standingFigure : String
    , movingSheet : String
    }


initBaseData : BaseData
initBaseData =
    { curId = 0
    , isPlaying = False
    }
