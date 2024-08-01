module SceneProtos.Story.Components.Sommsg.Init exposing (InitData, defaultMusic)

{-|


# Init module

@docs InitData, defaultMusic

-}

import Messenger.GeneralModel exposing (MsgBase(..))


{-| initial data of the music
-}
type alias InitData =
    { music : List ( String, Float, Int )
    , isPlaying : Bool
    }


{-| default music data
-}
defaultMusic : ( String, Float, Int )
defaultMusic =
    ( "", 0, 0 )
