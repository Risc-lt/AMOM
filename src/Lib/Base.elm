module Lib.Base exposing (SceneMsg(..))

import SceneProtos.Game.Init as GameInit
import SceneProtos.Story.Init as StoryInit


{-|


# Base

Base module for the game. Set the UserData and SceneMsg here.

@docs SceneMsg

-}
type SceneMsg
    = StoryInitData (StoryInit.InitData SceneMsg)
    | GameInitData (GameInit.InitData SceneMsg)
    | NullSceneMsg
