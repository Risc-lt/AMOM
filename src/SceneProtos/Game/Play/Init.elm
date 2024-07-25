module SceneProtos.Game.Play.Init exposing (InitData)

import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent)
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg, ComponentTarget)


{-|


# Init module

@docs InitData: The data used to initialize the scene.

-}
type alias InitData cdata scenemsg =
    { components : List (AbstractComponent cdata UserData ComponentTarget ComponentMsg BaseData scenemsg)
    }
