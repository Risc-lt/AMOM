module Scenes.Before3.Sommsgs exposing (..)

{-
   All music data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


sommsgInitData : InitData
sommsgInitData =
    { music =
        [ ( "eased", 24, 1 )
        , ( "battle", 24, 7 )
        ]
    , isPlaying = False
    }
