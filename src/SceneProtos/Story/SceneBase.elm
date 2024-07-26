module SceneProtos.Story.SceneBase exposing
    ( LayerMsg(..)
    , LayerTarget
    , SceneCommonData
    )

import SceneProtos.Story.StoryLayer.Init as StoryLayerInit


{-|


# SceneBase

Basic data for the scene.

@docs LayerTarget
@docs SceneCommonData
@docs LayerMsg

-}
type alias LayerTarget =
    String


{-| Common data
-}
type alias SceneCommonData =
    {}


{-| General message for layers
-}
type LayerMsg scenemsg
    = StoryLayerInitData (StoryLayerInit.InitData SceneCommonData scenemsg)
    | NullLayerMsg
