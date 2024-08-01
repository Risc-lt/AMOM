module Scenes.Before3.Characters2 exposing (arrange1, arrange2, arrange3, arrange4, arrange5, arrange6)

{-|


# Before3 Characters2 module

This module contains all character data for Before3 scene

@docs arrange1, arrange2, arrange3, arrange4, arrange5, arrange6

-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Direction(..), MoveKind(..), Movement, Posture(..), defaultMovement)


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


{-| Arange1 data
-}
arrange1 : List Movement
arrange1 =
    let
        move1 =
            None Right

        move2 =
            Real ( 990, 420 ) 8

        move3 =
            Real ( 890, 450 ) 8

        move4 =
            Real ( 890, 710 ) 8

        move5 =
            Real ( 890, 580 ) 8

        move6 =
            Real ( 890, 840 ) 8
    in
    [ genMove "Swordsman1" Battle move1 8
    , genMove "Swordsman2" Battle move2 8
    , genMove "Magician1" Battle move3 8
    , genMove "Magician2" Battle move4 8
    , genMove "Therapist1" Battle move5 8
    , genMove "Therapist2" Battle move6 8
    ]


{-| Arange2 data
-}
arrange2 : List Movement
arrange2 =
    let
        move2 =
            Real ( 1050, 420 ) 8

        move3 =
            Real ( 830, 450 ) 8

        move4 =
            Real ( 890, 650 ) 8

        move5 =
            Real ( 890, 520 ) 8

        move6 =
            Real ( 890, 780 ) 8
    in
    [ genMove "Swordsman2" Battle move2 9
    , genMove "Magician1" Battle move3 9
    , genMove "Magician2" Battle move4 9
    , genMove "Therapist1" Battle move5 9
    , genMove "Therapist2" Battle move6 9
    ]


{-| Arange3 data
-}
arrange3 : List Movement
arrange3 =
    let
        move2 =
            Real ( 1060, 330 ) 8

        move3 =
            Real ( 730, 450 ) 8

        move4 =
            Real ( 890, 550 ) 8

        move5 =
            Real ( 990, 520 ) 8

        move6 =
            Real ( 890, 680 ) 8
    in
    [ genMove "Swordsman2" Battle move2 10
    , genMove "Magician1" Battle move3 10
    , genMove "Magician2" Battle move4 10
    , genMove "Therapist1" Battle move5 10
    , genMove "Therapist2" Battle move6 10
    ]


{-| Arange4 data
-}
arrange4 : List Movement
arrange4 =
    let
        move2 =
            None Left

        move3 =
            None Right

        move4 =
            None Right

        move5 =
            Real ( 990, 490 ) 8

        move6 =
            Real ( 890, 650 ) 8
    in
    [ genMove "Swordsman2" Battle move2 11
    , genMove "Magician1" Battle move3 11
    , genMove "Magician2" Battle move4 11
    , genMove "Therapist1" Battle move5 11
    , genMove "Therapist2" Battle move6 11
    ]


{-| Arange5 data
-}
arrange5 : List Movement
arrange5 =
    let
        move5 =
            None Left

        move6 =
            Real ( 760, 580 ) 8
    in
    [ genMove "Therapist1" Battle move5 12
    , genMove "Therapist2" Battle move6 12
    ]


{-| Arange6 data
-}
arrange6 : List Movement
arrange6 =
    let
        move6 =
            None Right
    in
    [ genMove "Therapist2" Battle move6 13
    ]
