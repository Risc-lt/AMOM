module Scenes.After1.Sommsgs exposing (..)

{-
   All music data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


sommsgInitData : InitData
sommsgInitData =
    { music = [ ( "sad", 22, 0 ) ]
    , isPlaying = False
    }
