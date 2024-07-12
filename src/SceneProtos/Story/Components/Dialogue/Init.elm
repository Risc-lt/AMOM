module SceneProtos.Story.Components.Dialogue.Init exposing
    ( InitData
    , CreateInitData
    )

{-|


# Init module

@docs InitData

-}


{-| The data used to initialize the scene
-}
type alias InitData =
    { id : Int
    , speaker : String
    , content : String
    }


type alias CreateInitData =
    { speaker : String
    , content : List String
    }
