module Scenes.Before3.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


characters : List Character
characters =
    [ genCharacter "Wenderd" Normal Up 890 -140
    , genCharacter "Bulingze" Normal Up 900 -270
    , genCharacter "Bruce" Normal Up 880 -650
    , genCharacter "Bithif" Normal Up 900 -530
    , genCharacter "Cavalry" Normal Left 890 -400
    , genCharacter "Swordsman1" Battle Up 890 1080
    , genCharacter "Swordsman2" Battle Up 890 1210
    , genCharacter "Magician1" Battle Up 890 1340
    , genCharacter "Magician2" Battle Up 890 1600
    , genCharacter "Therapist1" Battle Up 890 1470
    , genCharacter "Therapist2" Battle Up 890 1730
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
            Real ( 890, 520 ) 5

        bulingzeMove =
            Real ( 900, 390 ) 5

        bruceMove =
            Real ( 880, 0 ) 5

        bithifMove =
            Real ( 900, 130 ) 5

        cavalryMove =
            Real ( 890, 260 ) 5
    in
    [ genMove "Wenderd" Normal wenderdMove 1
    , genMove "Bulingze" Normal bulingzeMove 1
    , genMove "Bruce" Normal bruceMove 1
    , genMove "Bithif" Normal bithifMove 1
    , genMove "Cavalry" Normal cavalryMove 1
    ]


followDown : List Movement
followDown =
    let
        move =
            Fake Down
    in
    [ genMove "Wenderd" Normal move 2
    , genMove "Bulingze" Normal move 2
    , genMove "Bruce" Normal move 2
    , genMove "Bithif" Normal move 2
    , genMove "Cavalry" Normal move 2
    ]


gather : List Movement
gather =
    let
        wenderdMove =
            Real ( 830, 520 ) 5

        bulingzeMove =
            Real ( 960, 510 ) 5

        bruceMove =
            Real ( 800, 390 ) 5

        bithifMove =
            Real ( 1050, 400 ) 5

        cavalryMove =
            Real ( 910, 390 ) 5
    in
    [ genMove "Wenderd" Normal wenderdMove 3
    , genMove "Bulingze" Normal bulingzeMove 3
    , genMove "Bruce" Normal bruceMove 3
    , genMove "Bithif" Normal bithifMove 3
    , genMove "Cavalry" Normal cavalryMove 3
    ]


turn : List Movement
turn =
    let
        wenderdMove =
            None Right

        bulingzeMove =
            None Left

        bruceMove =
            None Right

        bithifMove =
            None Left

        cavalryMove =
            None Right
    in
    [ genMove "Wenderd" Normal wenderdMove 4
    , genMove "Bulingze" Normal bulingzeMove 4
    , genMove "Bruce" Normal bruceMove 4
    , genMove "Bithif" Normal bithifMove 4
    , genMove "Cavalry" Normal cavalryMove 4
    ]


check : List Movement
check =
    let
        wenderdMove =
            Follow ( 830, -480 ) 8

        bulingzeMove =
            Follow ( 960, -490 ) 8

        bruceMove =
            Follow ( 800, -610 ) 8

        bithifMove =
            Follow ( 1050, -600 ) 8

        cavalryMove =
            Follow ( 910, -610 ) 8
    in
    [ genMove "Wenderd" Normal wenderdMove 6
    , genMove "Bulingze" Normal bulingzeMove 6
    , genMove "Bruce" Normal bruceMove 6
    , genMove "Bithif" Normal bithifMove 6
    , genMove "Cavalry" Normal cavalryMove 6
    ]


enemyAppear : List Movement
enemyAppear =
    let
        move1 =
            Real ( 890, 290 ) 8

        move2 =
            Real ( 890, 420 ) 8

        move3 =
            Real ( 890, 550 ) 8

        move4 =
            Real ( 890, 810 ) 8

        move5 =
            Real ( 890, 680 ) 8

        move6 =
            Real ( 890, 940 ) 8
    in
    [ genMove "Swordsman1" Battle move1 7
    , genMove "Swordsman2" Battle move2 7
    , genMove "Magician1" Battle move3 7
    , genMove "Magician2" Battle move4 7
    , genMove "Therapist1" Battle move5 7
    , genMove "Therapist2" Battle move6 7
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
            ++ followDown
            ++ gather
            ++ turn
            ++ check
            ++ enemyAppear
    }
