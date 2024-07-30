module Scenes.After3.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


characters : List Character
characters =
    [ genCharacter "Wenderd" Battle Right 830 320
    , genCharacter "Bulingze" Battle Left 960 310
    , genCharacter "Bruce" Battle Right 800 190
    , genCharacter "Bithif" Battle Left 1050 200
    , genCharacter "Cavalry" Battle Left 910 190
    , genCharacter "Swordsman1" Battle Right 890 490
    , genCharacter "Swordsman2" Battle Left 1060 530
    , genCharacter "Magician1" Battle Right 730 650
    , genCharacter "Magician2" Battle Right 890 750
    , genCharacter "Therapist1" Battle Left 990 690
    , genCharacter "Therapist2" Battle Right 760 780
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
    , remainMove = []
    }
