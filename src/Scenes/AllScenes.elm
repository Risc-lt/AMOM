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
        [ ( "Level1", Level1.scene )
        , ( "Begin", Begin.scene )
        , ( "Home", Home.scene )
        , ( "Instruction", Instruction.scene )
        ]
