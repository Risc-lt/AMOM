module Scenes.Before1.Sommsgs exposing (..)

{-
   All music data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


sommsgInitData : InitData
sommsgInitData =
    { music = [ ( "battle", 16, 0 ) ]
    , isPlaying = False
    }
