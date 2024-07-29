module Scenes.After2.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Right 1150 390
    , genCharacter "Bulingze" Battle Right 1270 550
    , genCharacter "Bruce" Battle Right 1400 350
    , genCharacter "Bithif" Battle Right 1400 490
    , genCharacter "Cavalry" Normal Left 890 480
    ]


genCharacter : String -> Posture -> Direction -> Float -> Float -> Character
genCharacter name posture direction x y =
    { defaultCharacter
        | name = name
        , posture = posture
        , direction = direction
        , x = x
        , y = y
    }


checkConcert : List Movement
checkConcert =
    let
        move =
            Real ( 1010, 480 ) 5
    in
    [ genMove "Wenderd" Normal move 2 ]


prevent : List Movement
prevent =
    let
        move =
            Real ( 1130, 480 ) 8
    in
    [ genMove "Bulingze" Battle move 4 ]


turnRight : List Movement
turnRight =
    let
        move =
            None Right
    in
    [ genMove "Bulingze" Battle move 6 ]


turnLeft : List Movement
turnLeft =
    let
        move =
            None Left
    in
    [ genMove "Bulingze" Battle move 8 ]


genMove : String -> Posture -> MoveKind -> Int -> Movement
genMove name posture movekind id =
    { defaultMovement
        | name = name
        , posture = posture
        , movekind = movekind
        , id = id
        , isMoving = False
    }


charInitData : InitData
charInitData =
    { characters = characters
    , curMove = []
    , remainMove =
        checkConcert
            ++ prevent
    }
