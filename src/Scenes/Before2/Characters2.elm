module Scenes.Before2.Characters2 exposing (charge5, charge6, charge7, charge8, charge9)

{-|


# Characters2 Module

@docs charge5, charge6, charge7, charge8, charge9

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


{-| Movement: Charge 5
-}
charge5 : List Movement
charge5 =
    let
        wenderdMove =
            Real ( 729, 400 ) 8

        bulingzeMove =
            Real ( 989, 470 ) 8

        bruceMove =
            Real ( 859, 400 ) 8

        bithifMove =
            Real ( 909, 760 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 12
    , genMove "Bulingze" Battle bulingzeMove 12
    , genMove "Bruce" Battle bruceMove 12
    , genMove "Bithif" Battle bithifMove 12
    ]


{-| Movement: Charge 6
-}
charge6 : List Movement
charge6 =
    let
        wenderdMove =
            Real ( 659, 400 ) 8

        bulingzeMove =
            Real ( 919, 470 ) 8

        bruceMove =
            Real ( 859, 330 ) 8

        bithifMove =
            Real ( 839, 760 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 13
    , genMove "Bulingze" Battle bulingzeMove 13
    , genMove "Bruce" Battle bruceMove 13
    , genMove "Bithif" Battle bithifMove 13
    ]


{-| Movement: Charge 7
-}
charge7 : List Movement
charge7 =
    let
        wenderdMove =
            Real ( 299, 400 ) 8

        bulingzeMove =
            Real ( 559, 470 ) 8

        bruceMove =
            Real ( 499, 330 ) 8

        bithifMove =
            Real ( 839, 400 ) 8

        concertMove =
            Real ( -280, 400 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 14
    , genMove "Bulingze" Battle bulingzeMove 14
    , genMove "Bruce" Battle bruceMove 14
    , genMove "Bithif" Battle bithifMove 14
    , genMove "Concert" Battle concertMove 14
    ]


{-| Movement: Charge 8
-}
charge8 : List Movement
charge8 =
    let
        move =
            Fake Left

        concertMove =
            Follow ( 20, 400 ) 8
    in
    [ genMove "Wenderd" Battle move 15
    , genMove "Bulingze" Battle move 15
    , genMove "Bruce" Battle move 15
    , genMove "Bithif" Battle move 15
    , genMove "Concert" Battle concertMove 15
    ]


{-| Movement: Charge 9
-}
charge9 : List Movement
charge9 =
    let
        wenderdMove =
            Real ( 299, 400 ) 8

        bulingzeMove =
            Real ( 499, 470 ) 8

        bruceMove =
            Real ( 499, 330 ) 8

        bithifMove =
            Real ( 699, 400 ) 8

        concertMove =
            None Right
    in
    [ genMove "Wenderd" Battle wenderdMove 16
    , genMove "Bulingze" Battle bulingzeMove 16
    , genMove "Bruce" Battle bruceMove 16
    , genMove "Bithif" Battle bithifMove 16
    , genMove "Concert" Battle concertMove 16
    ]
