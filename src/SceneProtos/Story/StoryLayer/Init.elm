module SceneProtos.Story.StoryLayer.Init exposing (InitData)

import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg, ComponentTarget)


{-|


# Init module

@docs InitData

-}
type alias InitData cdata scenemsg =
    { components : List (AbstractComponent cdata UserData ComponentTarget ComponentMsg BaseData scenemsg)
    }
