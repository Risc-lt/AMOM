module SceneProtos.Story.Components.ComponentBase exposing (BaseData, CharAction(..), CharSequenceDeliver, ComponentMsg(..), ComponentTarget)

import SceneProtos.Story.Components.Character.Init as Character
import SceneProtos.Story.Components.DialogSequence.Init as Dialogue


{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}
type ComponentMsg
    = BeginDialogue Int
    | CloseDialogue
    | DialogueInit Dialogue.InitData
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    Int


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
