module Scenes.Game.SceneBase exposing
    ( Element(..)
    , LayerMsg(..)
    , LayerTarget
    , SceneCommonData
    )

import Scenes.Game.Play.Init as PlayInit


{-|


# SceneBase

Basic data for the scene.

@docs LayerTarget: Layer target type
@docs SceneCommonData: Common data
@docs LayerMsg: General message for layers

-}
type alias LayerTarget =
    String


type alias SceneCommonData =
    { gameover : Bool }


type LayerMsg scenemsg
    = PlayInitData (PlayInit.InitData SceneCommonData scenemsg)
    | NullLayerMsg


type Element
    = Water
    | Fire
    | Wind
    | Earth
