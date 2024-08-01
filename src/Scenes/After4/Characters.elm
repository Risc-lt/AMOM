module Scenes.After4.Characters exposing
    ( charInitData
    , characters
    , genCharacter
    , genMove
    )

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


{-| Characters
-}
characters : List Character
characters =
    [ genCharacter "Bruce" Battle Right 890 80 ]


{-| Generate a character
-}
genCharacter : String -> Posture -> Direction -> Float -> Float -> Character
genCharacter name posture direction x y =
    { defaultCharacter
        | name = name
        , posture = posture
        , direction = direction
        , x = x
        , y = y
    }


{-| Generate a movement
-}
genMove : String -> Posture -> MoveKind -> Int -> Movement
genMove name posture movekind id =
    { defaultMovement
        | name = name
        , posture = posture
        , movekind = movekind
        , id = id
        , isMoving = False
    }


{-| Characters: Init data
-}
charInitData : InitData
charInitData =
    { characters = characters
    , curMove = []
    , remainMove = []
    }
