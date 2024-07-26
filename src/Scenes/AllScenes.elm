module Scenes.AllScenes exposing (allScenes)

{-|


# AllScenes

Record all the scenes here

@docs allScenes

-}

{- import Scenes.Level2.Model as Level2
   import Scenes.Level3.Model as Level3
-}

import Dict
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Scene.Scene exposing (AllScenes)
import Scenes.Level1.Model as Level1
import Scenes.Sample.Model as Sample


{-| All Scenes

Store all the scenes with their name here.

-}
allScenes : AllScenes UserData SceneMsg
allScenes =
    Dict.fromList
        [ ( "Sample", Sample.scene )
        , ( "Level1", Level1.scene )

        {- , ( "Level2", Level2.scene )
           , ( "Level3", Level3.scene )
        -}
        ]
