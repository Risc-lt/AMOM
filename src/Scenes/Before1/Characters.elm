module Scenes.Before1.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)
import Scenes.Level1.Characters exposing (bulingze)


characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Right -140 350
    , genCharacter "Bulingze" Battle Right -380 490
    , genCharacter "Bruce" Battle Right -620 350
    , genCharacter "Bithif" Battle Right -860 490
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
            Real ( 910, 350 ) 8

        bulingzeMove =
            Real ( 670, 490 ) 8

        bruceMove =
            Real ( 430, 350 ) 8

        bithifMove =
            Real ( 190, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 1
    , genMove "Bulingze" Battle bulingzeMove 1
    , genMove "Bruce" Battle bruceMove 1
    , genMove "Bithif" Battle bithifMove 1
    ]


followRight : List Movement
followRight =
    let
        movekind =
            Fake Right
    in
    [ genMove "Wenderd" Battle movekind 2
    , genMove "Bulingze" Battle movekind 2
    , genMove "Bruce" Battle movekind 2
    , genMove "Bithif" Battle movekind 2
    ]


bySelfRight : List Movement
bySelfRight =
    let
        wenderdMove =
            Real ( 1100, 490 ) 8

        bulingzeMove =
            Real ( 960, 490 ) 8

        bruceMove =
            Real ( 760, 350 ) 8

        bithifMove =
            Real ( 520, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 3
    , genMove "Bulingze" Battle bulingzeMove 3
    , genMove "Bruce" Battle bruceMove 3
    , genMove "Bithif" Battle bithifMove 3
    ]


throughStone1 : List Movement
throughStone1 =
    let
        wenderdMove =
            Real ( 1580, 490 ) 8

        bulingzeMove =
            Real ( 1420, 470 ) 8

        bruceMove =
            Real ( 1100, 490 ) 8

        bithifMove =
            Real ( 960, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 4
    , genMove "Bulingze" Battle bulingzeMove 4
    , genMove "Bruce" Battle bruceMove 4
    , genMove "Bithif" Battle bithifMove 4
    ]


throughStone2 : List Movement
throughStone2 =
    let
        wenderdMove =
            Real ( 1660, 450 ) 8

        bulingzeMove =
            Real ( 1420, 350 ) 8

        bruceMove =
            Real ( 1220, 490 ) 8

        bithifMove =
            Real ( 1080, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 5
    , genMove "Bulingze" Battle bulingzeMove 5
    , genMove "Bruce" Battle bruceMove 5
    , genMove "Bithif" Battle bithifMove 5
    ]


throughStone3 : List Movement
throughStone3 =
    let
        wenderdMove =
            Real ( 1660, 350 ) 8

        bulingzeMove =
            None Left

        bruceMove =
            Real ( 1320, 490 ) 8

        bithifMove =
            Real ( 1180, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 6
    , genMove "Bulingze" Battle bulingzeMove 6
    , genMove "Bruce" Battle bruceMove 6
    , genMove "Bithif" Battle bithifMove 6
    ]


throughStone4 : List Movement
throughStone4 =
    let
        wenderdMove =
            None Right

        bulingzeMove =
            None Left

        bruceMove =
            Real ( 1560, 490 ) 8

        bithifMove =
            Real ( 1420, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 7
    , genMove "Bulingze" Battle bulingzeMove 7
    , genMove "Bruce" Battle bruceMove 7
    , genMove "Bithif" Battle bithifMove 7
    ]


throughStone5 : List Movement
throughStone5 =
    let
        wenderdMove =
            None Right

        bulingzeMove =
            None Left

        bruceMove =
            Real ( 1660, 490 ) 8

        bithifMove =
            None Left
    in
    [ genMove "Wenderd" Battle wenderdMove 8
    , genMove "Bulingze" Battle bulingzeMove 8
    , genMove "Bruce" Battle bruceMove 8
    , genMove "Bithif" Battle bithifMove 8
    ]


followLeft : List Movement
followLeft =
    let
        wenderdMove =
            Follow ( 2299, 350 ) 8

        bulingzeMove =
            Follow ( 2059, 350 ) 8

        bruceMove =
            Follow ( 2299, 490 ) 8

        bithifMove =
            Follow ( 2059, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 10
    , genMove "Bulingze" Battle bulingzeMove 10
    , genMove "Bruce" Battle bruceMove 10
    , genMove "Bithif" Battle bithifMove 10
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
            ++ followRight
            ++ bySelfRight
            ++ throughStone1
            ++ throughStone2
            ++ throughStone3
            ++ throughStone4
            ++ throughStone5
            ++ followLeft
    }
