module SceneProtos.Story.Components.CharSequence.Init exposing
    ( InitData
    , Character, Direction(..), MoveKind(..), Movement, Posture(..)
    , defaultCharacter, defaultMovement
    )

{-|


# Init module

@docs InitData
@docs Character, Direction, MoveKind, Movement, Posture
@docs defaultCharacter, defaultMovement

-}


{-| Direction of the character
-}
type Direction
    = Right
    | Left
    | Up
    | Down


{-| Posture of the character
-}
type Posture
    = Normal
    | Battle
    | Fall


{-| The data structure for characters
-}
type alias Character =
    { name : String
    , direction : Direction
    , posture : Posture
    , x : Float
    , y : Float
    , speed : Float
    , isMoving : Bool
    }


{-| The data structure for movement kind
-}
type MoveKind
    = Real ( Float, Float ) Float
    | Follow ( Float, Float ) Float
    | Fake Direction
    | None Direction


{-| The data structure for movement
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


{-| Default character data
-}
defaultCharacter : Character
defaultCharacter =
    { name = ""
    , posture = Normal
    , direction = Right
    , x = 0
    , y = 0
    , speed = 0
    , isMoving = False
    }


{-| Default movement data
-}
defaultMovement : Movement
defaultMovement =
    { name = ""
    , posture = Normal
    , movekind = None Right
    , id = 0
    , isMoving = False
    }
