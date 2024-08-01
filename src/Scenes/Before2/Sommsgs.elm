module Scenes.Before2.Sommsgs exposing (..)

{-
   All music data
-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


sommsgInitData : InitData
sommsgInitData =
    { music =
        [ ( "eased", 24, 0 )
        , ( "battle", 16, 8 )
        ]
    , isPlaying = False
    }
