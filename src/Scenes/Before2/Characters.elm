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
    , genCharacter "Cavalry" Battle Left -500 490
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
            Follow ( 1699, 760 ) 8

        bulingzeMove =
            Follow ( 1899, 900 ) 8

        bruceMove =
            Follow ( 1839, 760 ) 8

        bithifMove =
            Follow ( 1699, 900 ) 8

        concertMove =
            Follow ( 139, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 5
    , genMove "Bulingze" Battle bulingzeMove 5
    , genMove "Bruce" Battle bruceMove 5
    , genMove "Bithif" Battle bithifMove 5
    , genMove "Cavalry" Battle concertMove 5
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
    }
