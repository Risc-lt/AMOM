module SceneProtos.Story.Init exposing (CameraSettings, Character, Dialogue, InitData)

import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (LevelComponentStorage)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg, ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


{-|


# Init module

@docs InitData

-}
type alias InitData scenemsg =
    { objects : List (LevelComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData scenemsg)
    , level : String
    }


type alias Dialogue =
    { speaker : String
    , text : String
    , imageId : String
    }


type alias Character =
    { id : Int
    , name : String
    , imageId : String
    }


type alias CameraSettings =
    { position : ( Int, Int )
    , movement : ( Int, Int )
    }
