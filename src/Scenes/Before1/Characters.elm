module Scenes.Before1.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


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
            Real ( 910, 490 ) 8

        bulingzeMove =
            Real ( 770, 490 ) 8

        bruceMove =
            Real ( 570, 350 ) 8

        bithifMove =
            Real ( 330, 490 ) 8
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
            Real ( 1390, 490 ) 8

        bulingzeMove =
            Real ( 1250, 490 ) 8

        bruceMove =
            Real ( 910, 490 ) 8

        bithifMove =
            Real ( 770, 490 ) 8
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
            Real ( 1660, 440 ) 8

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


followLeft : Movement
followLeft =
    let
        movekind =
            Follow ( 2299, 350 ) 8
    in
    genMove "Wenderd" Battle movekind 6


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
    { characters = [ wenderd ]
    , curMove = []
    , remainMove =
        [ begin
        , followRight
        , bySelfRight
        , throughStone
        , followLeft
        ]
    }
