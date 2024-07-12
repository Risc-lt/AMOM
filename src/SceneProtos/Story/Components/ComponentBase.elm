module SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)

import SceneProtos.Story.Components.Bithif.Init as Bithif
import SceneProtos.Story.Components.Bruce.Init as Bruce
import SceneProtos.Story.Components.Bulingze.Init as Bulingze
import SceneProtos.Story.Components.Character.Init as Character
import SceneProtos.Story.Components.Dialogue.Init as Dialogue
import SceneProtos.Story.Components.Wenderd.Init as Wendered


{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}
type ComponentMsg
    = NewDialogueMsg Dialogue.CreateInitData
    | NextDialogue Dialogue.CreateInitData
    | CloseDialogue
    | CameraMsg (Float,Float)
    | NewWenderdMsg (Float,Float)
    | VanishWenderdMsg 
    | NewBithifMsg (Float,Float)
    | VanishBithifMsg 
    | NewBruceMsg (Float,Float)
    | VanishBruceMsg 
    | NewBulingzeMsg (Float,Float)
    | VanishBulingzeMsg 
    | MoveTo (Float,Float)
    | SetBackgroundMsg (Float,Float)
    | NullComponentMsg

{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
