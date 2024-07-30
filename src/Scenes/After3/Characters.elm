module Scenes.After3.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Up 890 -140
    , genCharacter "Bulingze" Battle Up 900 -270
    , genCharacter "Bruce" Battle Up 880 -650
    , genCharacter "Bithif" Battle Up 900 -530
    , genCharacter "Cavalry" Battle Left 890 -400
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
    }
