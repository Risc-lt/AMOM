module Scenes.Before3.Sommsgs exposing (..)

{-
   All music data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


sommsgInitData : InitData
sommsgInitData =
    { music =
        [ ( "eased", 24, 0 )
        , ( "battle", 16, 7 )
        ]
    , isPlaying = False
    }
