module Scenes.Before2.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Up 1060 1080
    , genCharacter "Bulingze" Battle Up 1260 1280
    , genCharacter "Bruce" Battle Up 1200 1080
    , genCharacter "Bithif" Battle Up 1060 1280
    , genCharacter "Cavalry" Battle Left -300 400
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
        wenderdMove =
            Real ( 1060, 760 ) 8

        bulingzeMove =
            Real ( 1260, 900 ) 8

        bruceMove =
            Real ( 1200, 760 ) 8

        bithifMove =
            Real ( 1060, 900 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 1
    , genMove "Bulingze" Battle bulingzeMove 1
    , genMove "Bruce" Battle bruceMove 1
    , genMove "Bithif" Battle bithifMove 1
    ]


turnRight : List Movement
turnRight =
    let
        wenderdMove =
            None Right

        bulingzeMove =
            None Left

        bruceMove =
            None Left

        bithifMove =
            None Right
    in
    [ genMove "Wenderd" Battle wenderdMove 2
    , genMove "Bulingze" Battle bulingzeMove 2
    , genMove "Bruce" Battle bruceMove 2
    , genMove "Bithif" Battle bithifMove 2
    ]


turnLeft : List Movement
turnLeft =
    let
        wenderdMove =
            None Left

        bithifMove =
            None Left
    in
    [ genMove "Wenderd" Battle wenderdMove 4
    , genMove "Bithif" Battle bithifMove 4
    ]


followRight : List Movement
followRight =
    let
        wenderdMove =
            Follow ( 1399, 760 ) 8

        bulingzeMove =
            Follow ( 1599, 900 ) 8

        bruceMove =
            Follow ( 1539, 760 ) 8

        bithifMove =
            Follow ( 1399, 900 ) 8

        concertMove =
            Follow ( 39, 400 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 5
    , genMove "Bulingze" Battle bulingzeMove 5
    , genMove "Bruce" Battle bruceMove 5
    , genMove "Bithif" Battle bithifMove 5
    , genMove "Cavalry" Battle concertMove 5
    ]


concertLeft : List Movement
concertLeft =
    let
        concertMove =
            Real ( -150, 400 ) 2
    in
    [ genMove "Cavalry" Battle concertMove 6 ]


charge1 : List Movement
charge1 =
    let
        wenderdMove =
            Real ( 1259, 760 ) 8

        bulingzeMove =
            Real ( 1599, 760 ) 8

        bruceMove =
            Real ( 1399, 760 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 8
    , genMove "Bulingze" Battle bulingzeMove 8
    , genMove "Bruce" Battle bruceMove 8
    ]


charge2 : List Movement
charge2 =
    let
        wenderdMove =
            Real ( 989, 760 ) 8

        bulingzeMove =
            Real ( 1329, 760 ) 8

        bruceMove =
            Real ( 1129, 760 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 9
    , genMove "Bulingze" Battle bulingzeMove 9
    , genMove "Bruce" Battle bruceMove 9
    ]


charge3 : List Movement
charge3 =
    let
        wenderdMove =
            Real ( 859, 760 ) 8

        bulingzeMove =
            Real ( 1189, 760 ) 8

        bruceMove =
            Real ( 989, 760 ) 8

        bithifMove =
            Real ( 1399, 760 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 10
    , genMove "Bulingze" Battle bulingzeMove 10
    , genMove "Bruce" Battle bruceMove 10
    , genMove "Bithif" Battle bithifMove 10
    ]


charge4 : List Movement
charge4 =
    let
        wenderdMove =
            Real ( 859, 400 ) 8

        bulingzeMove =
            Real ( 989, 600 ) 8

        bruceMove =
            Real ( 859, 530 ) 8

        bithifMove =
            Real ( 1039, 760 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 11
    , genMove "Bulingze" Battle bulingzeMove 11
    , genMove "Bruce" Battle bruceMove 11
    , genMove "Bithif" Battle bithifMove 11
    ]


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
    , genMove "Cavalry" Battle concertMove 14
    ]


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
    , genMove "Cavalry" Battle concertMove 15
    ]


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
    , genMove "Cavalry" Battle concertMove 16
    ]


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
            ++ turnRight
            ++ turnLeft
            ++ followRight
            ++ concertLeft
            ++ charge1
            ++ charge2
            ++ charge3
            ++ charge4
            ++ charge5
            ++ charge6
            ++ charge7
            ++ charge8
            ++ charge9
    }
