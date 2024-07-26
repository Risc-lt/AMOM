module SceneProtos.Story.Components.CharSequence.Init exposing 
    (InitData
    , MoveKind(..), Direction(..), Posture(..), Movement, Character, defaultCharacter, defaultMovement)

{-|


# Init module

@docs InitData

-}


type Direction
    = Right
    | Left
    | Up
    | Down


type Posture
    = Normal
    | Battle


{- The data structure for characters
-}
type alias Character =
    { name : String
    , direction : Direction
    , posture : Posture
    , x : Float
    , y : Float
    , speed : Float
    }


type MoveKind
    = Follow ( Float, Float ) Float
    | BySelf ( Float, Float ) Float
    | Fake Direction
    | None


{- The data structure for movement
-}
type alias Movement =
    { name : String
    , posture : Posture
    , movekind : MoveKind
    , id : Int
    , isMoving : Bool
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    { characters : List Character
    , curMove : List Movement
    , remainMove : List Movement
    }


defaultCharacter : Character
defaultCharacter =
    { name = ""
    , direction = Right
    , posture = Normal
    , x = 0
    , y = 0
    , speed = 0
    }

defaultMovement : Movement
defaultMovement =
    { name = ""
    , posture = Normal
    , movekind = None
    , id = 0
    , isMoving = False
    }
