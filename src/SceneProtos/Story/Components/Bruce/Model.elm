module SceneProtos.Story.Components.Bruce.Model exposing (component)

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
import Messenger.Base exposing (UserEvent(..))
import SceneProtos.Story.Components.ComponentBase exposing (ComponentMsg(..))


type alias Data =
    { standingFigure : String
    , movingSheet : String
    , currentFrame : Int
    , position : ( Float, Float )
    , move : Bool
    , visible : Bool
    , dx : Float
    , dy : Float
    , destination : (Float,Float)
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    ( { standingFigure = "archer"
        , movingSheet = "archer"
        , currentFrame = 1
        , position = (0,0), move = False, visible = False, dx = 0, dy = 0, destination = (0,0)
    }, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        newPos =
            updatePos data.position data.dx data.dy
        newCurrentFrame =
            (modBy 4 (data.currentFrame + 1)) + 1
        newDestination = 
            if isReached data.position newPos data.destination then
                newPos
            else
                data.destination
        newMove =
            if isReached data.position newPos data.destination then
                True
            else
                False
    in
    case evnt of
        Tick dt ->  
            ( ( { data | position = newPos, currentFrame = newCurrentFrame , destination = newDestination, move = newMove }, basedata ), [], ( env, False ) )
        _ ->
            ( (  data, basedata ), [], ( env, False ) )
            
-- whether the Position is reach or over the destination
isReached : (Float,Float) -> (Float,Float) -> (Float,Float) -> Bool
isReached (originX,originY) (newX,newY) (desX,desY) =
    if (originX - desX)*(newX - desX) < 0 ||(originX - desX)*(newX - desX) == 0 then
        True
    else
        False


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        NewBruceMsg (x,y) ->
            let
                initPosition = (x,y)
            in
            ( ( { data | position = initPosition, visible = True }, basedata ), [], env )
        VanishBruceMsg -> 
            ( ( { data | visible = False }, basedata ), [], env )
        MoveTo (x,y) -> 
            let
                newDes = (x,y)
                newDX = (x - data.dx)/5
                newDY = (y - data.dy)/5
            in
            ( ( { data | move = True, destination = newDes, dx = newDX, dy = newDY }, basedata ), [], env )
        CameraMsg (x,y) ->
            let
                newDes = (x,y)
                newDX = (x - data.dx)/5
                newDY = (y - data.dy)/5
            in
            ( ( { data | move = True, destination = newDes, dx = newDX, dy = newDY }, basedata ), [], env )
        _ ->
            ( ( data, basedata ), [], env )

updatePos : (Float,Float) -> Float -> Float -> (Float,Float)
updatePos (x,y) dx dy =
    let
        newX = x+dx
        newY = y+dy
    in
        ( newX, newY )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    if data.visible == True then
        let
            newSprite = 
                if data.move then
                    data.movingSheet ++ "." ++ String.fromInt data.currentFrame
                else
                    data.standingFigure
        in
           ( Canvas.group 
           [] 
           [ renderSprite env.globalData.internalData [] data.position (150,0) newSprite
           ]
           , 52)
    else
    ( Canvas.empty, 52 ) -- z-index


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Bruce"


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
