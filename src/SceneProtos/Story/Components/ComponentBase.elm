module SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Camera)

import SceneProtos.Story.Components.Bithif.Init as Bithif
import SceneProtos.Story.Components.Bruce.Init as Bruce
import SceneProtos.Story.Components.Bulingze.Init as Bulingze
import SceneProtos.Story.Components.Character.Init as Character
import SceneProtos.Story.Components.Dialogue.Init as Dialogue
import SceneProtos.Story.Components.Wendered.Init as Wendered


{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}
type ComponentMsg
    = NewDialogueMsg Dialogue.CreateInitData
    | CameraMsg Camera
    | NewWenderedMsg 
    | NewBithifMsg 
    | NewBruceMsg 
    | NewBulingzeMsg 
    | NullComponentMsg

type alias Camera =
    { dx : Int
    , dy : Int
    }

{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
