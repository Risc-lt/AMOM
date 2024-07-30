module Scenes.Home.Init exposing (Data, Direction(..), ScenePic, getNext, getX, initData)

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
          , text = "This is the dialogue before Battle 1."
          }
        , { name = "background"
          , x = 1320
          , y = 300
          , w = 500
          , h = 400
          , id = 2
          , next = "Level1"
          , text = "This is the Battle 1."
          }
        , { name = "dialogue_2"
          , x = 1920
          , y = 300
          , w = 500
          , h = 400
          , id = 3
          , next = "After1"
          , text = "This is the dialogue after Battle 1."
          }
        , { name = "dialogue_3"
          , x = 2520
          , y = 300
          , w = 500
          , h = 400
          , id = 4
          , next = "Before2"
          , text = "This is the dialogue before Battle 2."
          }
        , { name = "background"
          , x = 3120
          , y = 300
          , w = 500
          , h = 400
          , id = 5
          , next = "Level1"
          , text = "This is the Battle 2."
          }
        , { name = "dialogue_4"
          , x = 3720
          , y = 300
          , w = 500
          , h = 400
          , id = 6
          , next = "After2"
          , text = "This is the dialogue after Battle 2."
          }
        , { name = "dialogue_3"
          , x = 4320
          , y = 300
          , w = 500
          , h = 400
          , id = 7
          , next = "Before3"
          , text = "This is the dialogue before Battle 3."
          }
        , { name = "background"
          , x = 4920
          , y = 300
          , w = 500
          , h = 400
          , id = 8
          , next = "Level1"
          , text = "This is the Battle 3."
          }
        , { name = "dialogue_4"
          , x = 5520
          , y = 300
          , w = 500
          , h = 400
          , id = 9
          , next = "After3"
          , text = "This is the dialogue after Battle 3."
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


getNext : Float -> List ScenePic -> String
getNext id sceneQueue =
    case List.head (List.filter (\scenePic -> scenePic.id == id) sceneQueue) of
        Just scenePic ->
            scenePic.next

        Nothing ->
            "Level1"
