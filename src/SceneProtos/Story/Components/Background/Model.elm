module SceneProtos.Story.Components.Background.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.Background.Init exposing (InitData)
import SceneProtos.Story.Components.Background.Init exposing (defaultBackground)
import SceneProtos.Story.Components.Background.Init exposing (defaultCamera)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        BackgroundInit deliver ->
            ( deliver, initBaseData )

        _ ->
            ( { background = defaultBackground
              , curMove = defaultCamera
              , remainMove = []
              }
            , initBaseData
            )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        newPos =
            updatePos data.position data.dx data.dy

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
            ( ( { data | position = newPos, destination = newDestination, move = newMove }, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )



-- whether the Position is reach or over the destination


isReached : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Bool
isReached ( originX, originY ) ( newX, newY ) ( desX, desY ) =
    if (originX - desX) * (newX - desX) < 0 || (originX - desX) * (newX - desX) == 0 then
        True

    else
        False


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        CameraMsg ( x, y ) ->
            let
                newDes =
                    ( x, y )

                newDX =
                    (x - data.dx) / 5

                newDY =
                    (y - data.dy) / 5
            in
            ( ( { data | move = True, destination = newDes, dx = newDX, dy = newDY }, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


updatePos : ( Float, Float ) -> Float -> Float -> ( Float, Float )
updatePos ( x, y ) dx dy =
    let
        newX =
            x + dx

        newY =
            y + dy
    in
    ( newX, newY )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( Canvas.empty, 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Background"


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
