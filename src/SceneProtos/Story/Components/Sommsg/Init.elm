module SceneProtos.Story.Components.Sommsg.Init exposing
    ( InitData
    , defaultMusic
    )

{-|


# Init module

@docs InitData

-}

import Messenger.GeneralModel exposing (MsgBase(..))


type alias InitData =
    { music : List ( String, Float, Int )
    , isPlaying : Bool
    }


defaultMusic : ( String, Float, Int )
defaultMusic =
    ( "", 0, 0 )
