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
    }
