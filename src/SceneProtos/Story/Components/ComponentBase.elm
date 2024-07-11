module SceneProtos.Story.Components.ComponentBase exposing (ComponentMsg(..), ComponentTarget, BaseData)

import SceneProtos.Story.Components.Character.Init as Character
import SceneProtos.Story.Components.Dialogue.Init as Dialogue

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}



type ComponentMsg
    = NewCharacter 
    | CameraMsg 
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
