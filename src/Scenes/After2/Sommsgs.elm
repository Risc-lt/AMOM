module Scenes.After2.Sommsgs exposing (..)

{-
   All music data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


sommsgInitData : InitData
sommsgInitData =
    { music = [ ( "sad", 22, 1 ) ]
    , isPlaying = False
    }
