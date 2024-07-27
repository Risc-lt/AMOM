module Scenes.Home.Init exposing (Data, Direction(..), ScenePic, getX, initData)

import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (UserEvent(..))
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Story.Components.CharSequence.Init exposing (Direction)


{-|


# Init module

@docs InitData

-}
type alias Data =
    { curScene : Float
    , sceneQueue : List ScenePic
    , direction : Direction
    , left : Float
    }


type Direction
    = Left
    | Right
    | Null


type alias ScenePic =
    { name : String
    , x : Float
    , y : Float
    , w : Float
    , h : Float
    , id : Float
    }


initData : Data
initData =
    { curScene = 1
    , sceneQueue =
        [ { name = "dialogue_1"
          , x = 720
          , y = 300
          , w = 500
          , h = 400
          , id = 1
          }
        , { name = "background"
          , x = 1320
          , y = 300
          , w = 500
          , h = 400
          , id = 2
          }
        , { name = "dialogue_1"
          , x = 1920
          , y = 300
          , w = 500
          , h = 400
          , id = 3
          }
        , { name = "dialogue_2"
          , x = 2520
          , y = 300
          , w = 500
          , h = 400
          , id = 4
          }
        , { name = "background"
          , x = 3120
          , y = 300
          , w = 500
          , h = 400
          , id = 5
          }
        , { name = "dialogue_2"
          , x = 3720
          , y = 300
          , w = 500
          , h = 400
          , id = 6
          }
        , { name = "dialogue_3"
          , x = 4320
          , y = 300
          , w = 500
          , h = 400
          , id = 7
          }
        , { name = "background"
          , x = 4920
          , y = 300
          , w = 500
          , h = 400
          , id = 8
          }
        , { name = "dialogue_3"
          , x = 5520
          , y = 300
          , w = 500
          , h = 400
          , id = 9
          }
        ]
    , direction = Null
    , left = 0
    }


getX : Float -> List ScenePic -> Float
getX id sceneQueue =
    case List.head (List.filter (\scenePic -> scenePic.id == id) sceneQueue) of
        Just scenePic ->
            scenePic.x

        Nothing ->
            0
