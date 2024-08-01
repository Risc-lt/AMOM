module Scenes.After1.Sommsgs exposing (sommsgInitData)

{-|


# Sommsgs module

This module is used to generate the sommsgs for the scene.

@docs sommsgInitData

-}

import SceneProtos.Story.Components.Sommsg.Init exposing (InitData)


{-| The initial data for the sommsg
-}
sommsgInitData : InitData
sommsgInitData =
    { music = [ ( "sad", 22, 0 ) ]
    , isPlaying = False
    }