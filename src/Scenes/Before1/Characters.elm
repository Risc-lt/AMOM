module Scenes.Before1.Characters exposing (..)

{-
    All charater data
-}

import SceneProtos.Story.Components.CharSequence.Init exposing (InitData, Character, defaultCharacter)
import SceneProtos.Story.Components.CharSequence.Init exposing (Posture(..))
import SceneProtos.Story.Components.CharSequence.Init exposing (Direction(..))
import SceneProtos.Story.Components.CharSequence.Init exposing (MoveKind(..))
import SceneProtos.Story.Components.CharSequence.Init exposing (Movement, defaultMovement)


wenderd : Character
wenderd =
    genCharacter "Wenderd" Battle Right 0 0


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
            Real ( 910, 490 ) 5
    in
    genMove "Wenderd" Battle movekind 1


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
    , remainMove = [ begin ]
    }
