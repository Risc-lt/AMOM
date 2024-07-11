module SceneProtos.Story.Components.Bulingze.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg, ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import Messenger.Render.Sprite exposing (renderSprite)


type alias Data =
    { standingFigure : String
    , movingSheet : String
    , currentFrame : Int
    , position : ( Float, Float )
    , dx : Int
    , dy : Int
    , visible : Bool
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    ( { standingFigure = "archer"
        , movingSheet = "archer"
        , currentFrame = 1
        , position = (0,0), dx = 0, dy = 0, visible = False
    }, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        newPos =
            Tuple.mapFirst ((+) (toFloat data.dx)) data.position
                |> Tuple.mapSecond ((+) (toFloat data.dy))
    in
    ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.visible == True then
        let
            newSprite = 
                if data.dx /= 0 || data.dy /= 0 then
                    data.movingSheet ++ String.fromInt data.currentFrame
                else
                    data.standingFigure
        in
           ( Canvas.group 
           [] 
           [ renderSprite env.globalData.internalData [] data.position (150,0) newSprite
           ]
           , 53)
    else
    ( Canvas.empty, 53 ) -- z-index

matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Bulingze"


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Component generator
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
