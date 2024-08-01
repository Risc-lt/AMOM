module Scenes.Before1.Characters2 exposing (characters, genMove)

{-|


# Before1 Characters2 module

This module contains all character data for Before1 scene

@docs characters, genMove

-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


{-| All character data
-}
characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Right -140 350
    , genCharacter "Bulingze" Battle Right -380 490
    , genCharacter "Bruce" Battle Right -620 350
    , genCharacter "Bithif" Battle Right -860 490
    , genCharacter "Wild Wolf1" Battle Right -140 350
    , genCharacter "Wild Wolf2" Battle Right -210 490
    , genCharacter "Wild Wolf3" Battle Right -290 350
    , genCharacter "Wild Wolf4" Battle Right -360 520
    , genCharacter "Wild Wolf5" Battle Right -500 420
    , genCharacter "Wild Wolf6" Battle Right -620 350
    ]


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
