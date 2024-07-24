module SceneProtos.Story.Components.Character.Msg exposing (..)



type Name
    = Bithif
    | Bruce
    | Bulingze
    | Wenderd

type alias OneCharacter =
    { standingFigure : String
    , movingSheet : String
    , currentFrame : Int
    , position : ( Float, Float )
    , move : Bool
    , visible : Bool
    , dx : Float
    , dy : Float
    , destination : ( Float, Float )
    }

type alias Init =
    { allCharacter : List OneCharacter }

type alias Characters =
    { allCharacter : List OneCharacter}