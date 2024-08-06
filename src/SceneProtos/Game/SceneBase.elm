module SceneProtos.Game.SceneBase exposing
    ( LayerMsg(..)
    , LayerTarget
    , SceneCommonData
    )

{-|


# SceneBase

Basic data for the scene.

@docs LayerTarget: Layer target type
@docs SceneCommonData: Common data
@docs LayerMsg: General message for layers

-}

import SceneProtos.Game.Play.Init as PlayInit


type alias LayerTarget =
    String


type alias SceneCommonData =
    { gameover : Bool }


type LayerMsg scenemsg
    = PlayInitData (PlayInit.InitData SceneCommonData scenemsg)
    | NullLayerMsg
