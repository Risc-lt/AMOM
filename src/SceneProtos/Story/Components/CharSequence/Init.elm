module SceneProtos.Story.Components.CharSequence.Init exposing 
    (InitData
    , Direction(..), defaultCharacter, defaultMovement)

{-|


# Init module

@docs InitData

-}


type Direction
    = MoveLeft Float
    | MoveUp Float
    | MoveDown Float
    | MoveRight Float
    | Still


{- The data structure for characters
-}
type alias Character =
    { name : String
    , x : Float
    , y : Float
    , speed : Float
    , direction : Direction
    }


{- The data structure for movement
-}
type alias Movement =
    { name : String
    , destination : ( Float, Float )
    , id : Int
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    { characters : List Character
    , curMove : List Movement
    , movement : List Movement
    }


defaultCharacter : Character
defaultCharacter =
    { name = ""
    , x = 0
    , y = 0
    , speed = 0
    , direction = Still
    }

defaultMovement : Movement
defaultMovement =
    { name = ""
    , destination = ( 0, 0 )
    , id = 0
    }
