module Scenes.AllScenes exposing (allScenes)

{-|


# AllScenes

Record all the scenes here

@docs allScenes

-}

import Dict
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Scene.Scene exposing (AllScenes)
import Scenes.Game.Model as Game
import Scenes.Level1.Model as Level1
import Scenes.SampleScene.Model as SampleScene


{-| All Scenes

Store all the scenes with their name here.

-}
allScenes : AllScenes UserData SceneMsg
allScenes =
    Dict.fromList
        [ ( "Game", Game.scene )
        , ( "SampleScene", SampleScene.scene )
        , ( "Level1", Level1.scene )
        ]
