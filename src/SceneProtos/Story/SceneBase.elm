module SceneProtos.Story.SceneBase exposing
    ( LayerTarget
    , SceneCommonData
    , LayerMsg(..)
    )

{-|


# SceneBase

Basic data for the scene.

@docs LayerTarget
@docs SceneCommonData
@docs LayerMsg

-}

import SceneProtos.Story.StoryLayer.Init as StoryLayerInit


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
