module Lib.Base exposing (SceneMsg(..))

{-|


# Base

Base module for the game. Set the UserData and SceneMsg here.

@docs SceneMsg

-}

import SceneProtos.Game.Init as GameInit
import SceneProtos.Story.Init as StoryInit


{-| The SceneMsg type
-}
type SceneMsg
    = StoryInitData (StoryInit.InitData SceneMsg)
    | GameInitData (GameInit.InitData SceneMsg)
    | NullSceneMsg
