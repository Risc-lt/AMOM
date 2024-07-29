module Scenes.Before2.Characters exposing (..)

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
