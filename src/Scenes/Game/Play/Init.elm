module Scenes.Game.Play.Init exposing
    ( GameComponent
    , InitData
    )

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg, ComponentTarget)
import Scenes.Game.SceneBase exposing (SceneCommonData)


{-|


# Init module

@docs InitData: The data used to initialize the scene.
@docs GameComponent: Component configuration type.

-}
type alias InitData =
    { components : List GameComponent
    }


type alias GameComponent =
    AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
