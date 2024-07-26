module SceneProtos.Story.Components.ComponentBase exposing (BaseData, CharAction(..), CharSequenceDeliver, ComponentMsg(..), ComponentTarget)

import SceneProtos.Story.Components.Character.Init as Character
import SceneProtos.Story.Components.Dialogue.Init as Dialogue
import Scenes.Game.Components.ComponentBase exposing (ComponentMsg(..))


{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}
type ComponentMsg
    = NewDialogueMsg (List Dialogue.CreateInitData)
    | NextDialogue Dialogue.CreateInitData
    | CloseDialogue
    | NewDialogSequenceMsg DialogSequenceDeliver
    | NewCharSequenceMsg InitCharSequenceDeliver
    | UpdateCharSequenceMsg CharSequenceDeliver
    | VanishCharSequenceMsg
    | CameraSequenceMsg CharAction
    | CameraMsg ( Float, Float )
    | NewWenderdMsg ( Float, Float )
    | VanishWenderdMsg
    | NewBithifMsg ( Float, Float )
    | VanishBithifMsg
    | NewBruceMsg ( Float, Float )
    | VanishBruceMsg
    | NewBulingzeMsg ( Float, Float )
    | VanishBulingzeMsg
    | MoveTo ( Float, Float )
    | SetBackgroundMsg ( Float, Float )
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()


type CharAction
    = MoveLeft Float
    | MoveUp Float
    | MoveDown Float
    | MoveRight Float
    | Still


type alias DialogSequenceDeliver =
    { speaker : String
    , content : List String
    , next : List ComponentMsg
    , nextTar : List String
    }


type alias Object =
    { standingFigure : String
    , movingSheet : String
    }


type alias InitCharSequenceDeliver =
    { object : Object
    , id : Int
    , action : CharAction
    , nextMsg : List ComponentMsg
    , nextTar : List String
    , position : ( Float, Float )
    }


type alias CharSequenceDeliver =
    { object : Object
    , id : Int
    , action : CharAction
    , nextMsg : List ComponentMsg
    , nextTar : List String
    }
