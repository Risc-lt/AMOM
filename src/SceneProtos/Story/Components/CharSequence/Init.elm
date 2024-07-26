module SceneProtos.Story.Components.CharSequence.Init exposing 
    (InitData
    , defaultCharacter, defaultMovement)

{-|


# Init module

@docs InitData

-}


{- The data structure for characters
-}
type alias Character =
    { name : String
    , x : Float
    , y : Float
    }


{- The data structure for movement
-}
type alias Movement =
    { name : String
    , speed : Float
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
    }

defaultMovement : Movement
defaultMovement =
    { name = ""
    , speed = 0
    , destination = ( 0, 0 )
    , id = 0
    }
