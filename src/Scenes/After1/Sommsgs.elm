module Scenes.After1.Sommsgs exposing (..)

{-
   All dialogue data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData, defaultMusic)

sommsgInitData : InitData
sommsgInitData =
    { music = [ ( "Battle", 16, 1 ) ]
    , isPlaying = False
    }
