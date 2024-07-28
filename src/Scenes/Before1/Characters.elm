module Scenes.Before1.Characters exposing (..)

{-
   All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, Posture(..), defaultCharacter, defaultMovement)


wenderd : Character
wenderd =
    genCharacter "Wenderd" Battle Right 0 390


genCharacter : String -> Posture -> Direction -> Float -> Float -> Character
genCharacter name posture direction x y =
    { defaultCharacter
        | name = name
        , posture = posture
        , direction = direction
        , x = x
        , y = y
    }


begin : Movement
begin =
    let
        movekind =
            Real ( 910, 390 ) 8
    in
    genMove "Wenderd" Battle movekind 1


followRight : Movement
followRight =
    let
        movekind =
            Fake Right
    in
    genMove "Wenderd" Battle movekind 2


bySelfRight : Movement
bySelfRight =
    let
        movekind =
            Real ( 1120, 390 ) 8
    in
    genMove "Wenderd" Battle movekind 3


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
        ]
    }
