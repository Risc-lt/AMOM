module Scenes.After1.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Right 1150 390
    , genCharacter "Bulingze" Battle Right 1170 550
    , genCharacter "Bruce" Battle Right 1300 350
    , genCharacter "Bithif" Battle Right 1300 490
    , genCharacter "Wild Wolf1" Battle Right 540 350
    , genCharacter "Wild Wolf2" Battle Right 610 490
    , genCharacter "Wild Wolf3" Battle Right 690 350
    , genCharacter "Wild Wolf4" Battle Right 760 520
    , genCharacter "Wild Wolf5" Battle Right 900 420
    , genCharacter "Wild Wolf6" Battle Right 860 320
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


begin : List Movement
begin =
    let
        move =
            None Left
    in
    [ genMove "Wenderd" Normal move 1
    , genMove "Bulingze" Normal move 1
    , genMove "Bruce" Normal move 1
    , genMove "Bithif" Normal move 1
    ]


checkWolf : List Movement
checkWolf =
    let
        move =
            Real ( 1020, 405 ) 2
    in
    [ genMove "Wenderd" Normal move 3 ]


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
        begin
            ++ checkWolf
    }
