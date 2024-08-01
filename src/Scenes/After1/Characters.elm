module Scenes.After1.Characters exposing
    ( begin, checkWolf, turn
    , charInitData
    )

{-|


# Characters module

This module is used to generate the characters for the scene.

@docs characters, begin, checkWolf, turn

-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


{-| All character data
-}
characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Left 1150 390
    , genCharacter "Bulingze" Battle Left 1170 550
    , genCharacter "Bruce" Battle Left 1300 350
    , genCharacter "Bithif" Battle Left 1300 490
    , genCharacter "Wild Wolf1" Fall Right 540 350
    , genCharacter "Wild Wolf2" Fall Right 610 490
    , genCharacter "Wild Wolf3" Fall Right 690 350
    , genCharacter "Wild Wolf4" Fall Right 760 520
    , genCharacter "Wild Wolf5" Fall Right 900 420
    , genCharacter "Wild Wolf6" Fall Right 860 320
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


{-| Movement: Begin
-}
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


{-| Movement: Check Wolf
-}
checkWolf : List Movement
checkWolf =
    let
        move =
            Real ( 1020, 405 ) 1.5
    in
    [ genMove "Wenderd" Normal move 3 ]


{-| Movement: Turn
-}
turn : List Movement
turn =
    let
        move =
            None Left
    in
    [ genMove "Wenderd" Normal move 4 ]


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
        begin
            ++ checkWolf
            ++ turn
    }
