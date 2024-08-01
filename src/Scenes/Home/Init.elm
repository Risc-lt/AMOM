module Scenes.Home.Init exposing (Data, Direction(..), ScenePic, get, initData)

{-|


# Init module

@docs Data, Direction, ScenePic, get, initData

-}

import Messenger.Audio.Base exposing (AudioOption(..))
import Messenger.Base exposing (UserEvent(..))
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Story.Components.CharSequence.Init exposing (Direction)


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
    , next : String
    , text : String
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
          , next = "Before1"
          , text = "Chapter One: First Commision (Before Battle)"
          }
        , { name = "background"
          , x = 1320
          , y = 300
          , w = 500
          , h = 400
          , id = 2
          , next = "Level1"
          , text = "Chapter One: First Commision (Battle)"
          }
        , { name = "dialogue_1"
          , x = 1920
          , y = 300
          , w = 500
          , h = 400
          , id = 3
          , next = "After1"
          , text = "Chapter One: First Commision (After Battle)"
          }
        , { name = "dialogue_3"
          , x = 2520
          , y = 300
          , w = 500
          , h = 400
          , id = 4
          , next = "Before2"
          , text = "Chapter Two: Sinful Killing (Before Battle)"
          }
        , { name = "background"
          , x = 3120
          , y = 300
          , w = 500
          , h = 400
          , id = 5
          , next = "Level2"
          , text = "Chapter Two: Sinful Killing (Battle)"
          }
        , { name = "dialogue_3"
          , x = 3720
          , y = 300
          , w = 500
          , h = 400
          , id = 6
          , next = "After2"
          , text = "Chapter Two: Sinful Killing (After Battle)"
          }
        , { name = "dialogue_4"
          , x = 4320
          , y = 300
          , w = 500
          , h = 400
          , id = 7
          , next = "Before3"
          , text = "Chapter Three: Enemies from the North (Before Battle)"
          }
        , { name = "background"
          , x = 4920
          , y = 300
          , w = 500
          , h = 400
          , id = 8
          , next = "Level3"
          , text = "Chapter Three: Enemies from the North (Battle)"
          }
        , { name = "dialogue_4"
          , x = 5520
          , y = 300
          , w = 500
          , h = 400
          , id = 9
          , next = "After3"
          , text = "Chapter Three: Enemies from the North (After Battle)"
          }
        ]
    , direction = Null
    , left = 0
    }


get : Float -> List ScenePic -> ( Float, String )
get id sceneQueue =
    case List.head (List.filter (\scenePic -> scenePic.id == id) sceneQueue) of
        Just scenePic ->
            ( scenePic.x, scenePic.next )

        Nothing ->
            ( 0, "Level1" )
