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
import Scenes.Background.Model as Background
import Scenes.Charactermoving.Model as Charactermoving
import Scenes.Dialogue.Model as Dialogue
import Scenes.Game.Model as Game
import Scenes.SampleStory.Model as SampleStory
import Scenes.Level1.Model as Level1
import Scenes.Viewangle.Model as Viewangle


{-| All Scenes

Store all the scenes with their name here.

-}
allScenes : AllScenes UserData SceneMsg
allScenes =
    Dict.fromList
        [ ( "Game", Game.scene )
        , ( "SampleStory", SampleStory.scene )
        , ( "Level1", Level1.scene )
        , ( "Background", Background.scene )
        , ( "Dialogue", Dialogue.scene )
        , ( "Charactermoving", Charactermoving.scene )
        , ( "Viewangle", Viewangle.scene )
        ]
