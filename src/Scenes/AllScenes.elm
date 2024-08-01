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
import Scenes.After1.Model as After1
import Scenes.After2.Model as After2
import Scenes.After3.Model as After3
import Scenes.After4.Model as After4
import Scenes.Before1.Model as Before1
import Scenes.Before2.Model as Before2
import Scenes.Before3.Model as Before3
import Scenes.Begin.Model as Begin
import Scenes.End.Model as End
import Scenes.Home.Model as Home
import Scenes.Level1.Model as Level1
import Scenes.Level2.Model as Level2
import Scenes.Level3.Model as Level3
import Scenes.Logo.Model as Logo


{-| All Scenes

Store all the scenes with their name here.

-}
allScenes : AllScenes UserData SceneMsg
allScenes =
    Dict.fromList
        [ ( "Before1", Before1.scene )
        , ( "Level1", Level1.scene )
        , ( "After1", After1.scene )
        , ( "Before2", Before2.scene )
        , ( "Level2", Level2.scene )
        , ( "After2", After2.scene )
        , ( "Before3", Before3.scene )
        , ( "Level3", Level3.scene )
        , ( "After3", After3.scene )
        , ( "After4", After4.scene )
        , ( "Begin", Begin.scene )
        , ( "Home", Home.scene )
        , ( "Logo", Logo.scene )
        , ( "End", End.scene )
        ]
