module SceneProtos.Story.Init exposing
    ( InitData
    , Dialogue, Character, CameraSettings
    )

{-|


# Init module

@docs InitData
@docs Dialogue, Character, CameraSettings

-}

import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (LevelComponentStorage)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg, ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


{-| The initial data for the StroryTrigger component
-}
type alias InitData scenemsg =
    { objects : List (LevelComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData scenemsg)
    , level : String
    }


{-| Dialogue data
-}
type alias Dialogue =
    { speaker : String
    , text : String
    , imageId : String
    }


{-| Character data
-}
type alias Character =
    { id : Int
    , name : String
    , imageId : String
    }


{-| Camera settings
-}
type alias CameraSettings =
    { position : ( Int, Int )
    , movement : ( Int, Int )
    }
