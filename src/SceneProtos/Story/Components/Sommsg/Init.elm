module SceneProtos.Story.Components.Sommsg.Init exposing 
    ( InitData
    , defaultInitData)

{-|


# Init module

@docs InitData

-}
import Messenger.GeneralModel exposing (MsgBase(..))


type alias InitData =
    { music : List ( String, Int )
    , isPlaying : Bool
    }
    


defaultInitData : List ( String, Int )
defaultInitData =
    [ ( "", 0 ) ]
