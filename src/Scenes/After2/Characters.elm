module Scenes.After2.Characters exposing (charInitData)

{-|


# Characters module

This module is used to generate the characters for the scene.

@docs charInitData

-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


{-| The characters in the scene
-}
characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Left 1150 390
    , genCharacter "Bulingze" Battle Left 1270 550
    , genCharacter "Bruce" Battle Left 1400 350
    , genCharacter "Bithif" Battle Left 1400 490
    , genCharacter "Concert" Fall Right 890 480
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
turnLeft1 : List Movement
turnLeft1 =
    let
        move =
            None Left
    in
    [ genMove "Wenderd" Normal move 3 ]


{-| The movements of the characters
-}
prevent : List Movement
prevent =
    let
        move =
            Real ( 1130, 480 ) 8
    in
    [ genMove "Bulingze" Battle move 5 ]


{-| The movements of the characters
-}
turnLeft2 : List Movement
turnLeft2 =
    let
        move =
            None Left
    in
    [ genMove "Bulingze" Battle move 6 ]


{-| The movements of the characters
-}
fall : List Movement
fall =
    let
        move =
            None Left
    in
    [ genMove "Wenderd" Fall move 7 ]


turnRight : List Movement
turnRight =
    let
        move =
            None Right
    in
    [ genMove "Bulingze" Battle move 9 ]


turnLeft3 : List Movement
turnLeft3 =
    let
        move =
            None Left
    in
    [ genMove "Bulingze" Battle move 11 ]


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
            ++ turnLeft1
            ++ prevent
            ++ turnLeft2
            ++ fall
            ++ turnRight
            ++ turnLeft3
    }
