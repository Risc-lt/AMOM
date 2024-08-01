module Scenes.After2.Characters exposing (charInitData, characters, checkConcert, prevent, turnLeft, turnRight)

{-|


# Characters module

This module is used to generate the characters for the scene.

@docs charInitData, characters, checkConcert, prevent, turnLeft, turnRight

-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


{-| The characters in the scene
-}
characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Right 1150 390
    , genCharacter "Bulingze" Battle Right 1270 550
    , genCharacter "Bruce" Battle Right 1400 350
    , genCharacter "Bithif" Battle Right 1400 490
    , genCharacter "Concert" Normal Left 890 480
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


{-| The movements of the characters
-}
checkConcert : List Movement
checkConcert =
    let
        move =
            Real ( 1010, 480 ) 5
    in
    [ genMove "Wenderd" Normal move 2 ]


{-| The movements of the characters
-}
prevent : List Movement
prevent =
    let
        move =
            Real ( 1130, 480 ) 8
    in
    [ genMove "Bulingze" Battle move 4 ]


{-| The movements of the characters to turn right
-}
turnRight : List Movement
turnRight =
    let
        move =
            None Right
    in
    [ genMove "Bulingze" Battle move 6 ]


{-| The movements of the characters to turn left
-}
turnLeft : List Movement
turnLeft =
    let
        move =
            None Left
    in
    [ genMove "Bulingze" Battle move 8 ]


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


{-| The initial data for the characters
-}
charInitData : InitData
charInitData =
    { characters = characters
    , curMove = []
    , remainMove =
        checkConcert
            ++ prevent
    }
