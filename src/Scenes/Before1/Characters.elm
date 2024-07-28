module Scenes.Before1.Characters exposing (..)

{-
    All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (InitData, Character, defaultCharacter)


genCharacter : Character
genCharacter =
    { defaultCharacter
    | name = ""
    , posture = Normal
    , direction = Right
    , x = 0
    , y = 0
    , speed = 0
    , isMoving = False
    }


charInitData : InitData
charInitData = 
    { characters = []
    , curMove = []
    , remainMove = []
    }
