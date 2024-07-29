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
import Scenes.Before1.Model as Before1
import Scenes.Begin.Model as Begin
import Scenes.Home.Model as Home
import Scenes.Instruction.Model as Instruction
import Scenes.Level1.Model as Level1


{-| All Scenes

Store all the scenes with their name here.

-}
allScenes : AllScenes UserData SceneMsg
allScenes =
    Dict.fromList
        [ ( "Before1", Before1.scene )
        , ( "Level1", Level1.scene )
        , ( "After1", After1.scene )
        , ( "Begin", Begin.scene )
        , ( "Home", Home.scene )
        , ( "Instruction", Instruction.scene )
        ]
