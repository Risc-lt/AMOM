module SceneProtos.Story.Components.CharSequence.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Sprite exposing (renderSprite)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, CharAction(..), ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


type alias Data =
    { standingFigure : String
    , movingSheet : String
    , currentFrame : Int
    , position : ( Float, Float )
    , visible : Bool
    , dx : Float
    , dy : Float
    , action : CharAction
    , id : Int
    , destination : ( Float, Float )
    , next : List ComponentMsg
    , nextTar : List String
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    initOne env initMsg


initOne : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
initOne env initMsg =
    case initMsg of
        NewCharSequenceMsg deliver ->
            let
                ( desX, desY ) =
                    case deliver.action of
                        Still ->
                            deliver.position

                        MoveLeft x ->
                            ( Tuple.first deliver.position - x, Tuple.second deliver.position )

                        MoveRight x ->
                            ( Tuple.first deliver.position + x, Tuple.second deliver.position )

                        MoveUp y ->
                            ( Tuple.first deliver.position, Tuple.second deliver.position - y )

                        MoveDown y ->
                            ( Tuple.first deliver.position, Tuple.second deliver.position + y )
            in
            ( { standingFigure = deliver.object.standingFigure
              , movingSheet = deliver.object.movingSheet
              , currentFrame = 1
              , position = deliver.position
              , visible = True
              , dx = 5
              , dy = 5
              , action = deliver.action
              , id = deliver.id
              , destination = ( desX, desY )
              , nextTar = deliver.nextTar
              , next = deliver.nextMsg
              }
            , ()
            )

        _ ->
            let
                act =
                    Still
            in
            ( { standingFigure = "magician"
              , movingSheet = "magician"
              , currentFrame = 1
              , position = ( 0, 0 )
              , visible = False
              , dx = 0
              , dy = 0
              , action = act
              , id = 0
              , destination = ( 0, 0 )
              , next = [ NullComponentMsg ]
              , nextTar = []
              }
            , ()
            )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        newPos =
            case data.action of
                MoveLeft x ->
                    updatePos data.position -data.dx 0

                MoveRight x ->
                    updatePos data.position data.dx 0

                MoveUp y ->
                    updatePos data.position 0 -data.dy

                MoveDown y ->
                    updatePos data.position 0 data.dy

                Still ->
                    data.position

        newCurrentFrame =
            modBy 4 (data.currentFrame + 1) + 1

        newDestination =
            if isReachedX data.position newPos data.destination && isReachedY data.position newPos data.destination then
                data.destination

            else
                newPos

        newTar =
            data.nextTar

        msgList =
            List.map2 Tuple.pair newTar data.next

        newMsg =
            List.head data.next

        newAct =
            if newDestination == data.destination then
                Still

            else
                data.action

        sendMsg =
            if newMsg == Just NullComponentMsg then
                ( ( data, basedata ), [], ( env, False ) )

            else
                ( ( { data | position = newPos, currentFrame = newCurrentFrame, destination = newDestination, action = newAct }, basedata ), List.map (\item -> Other item) msgList, ( env, False ) )
    in
    case evnt of
        Tick dt ->
            if not (data.action == Still) then
                ( ( { data | position = newPos, currentFrame = newCurrentFrame, destination = newDestination, action = newAct }, basedata ), [], ( env, False ) )

            else
                sendMsg

        _ ->
            ( ( data, basedata ), [], ( env, False ) )



-- whether the Position is reach or over the destination


isReachedX : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Bool
isReachedX ( originX, originY ) ( newX, newY ) ( desX, desY ) =
    if (originX - desX) * (newX - desX) < 0 || (originX - desX) * (newX - desX) == 0 then
        True

    else
        False


isReachedY : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Bool
isReachedY ( originX, originY ) ( newX, newY ) ( desX, desY ) =
    if (originY - desY) * (newY - desY) < 0 || (originY - desY) * (newY - desY) == 0 then
        True

    else
        False


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        UpdateCharSequenceMsg deliver ->
            let
                initPosition =
                    data.position

                newAct =
                    deliver.action
            in
            ( ( { data | position = initPosition, visible = True, action = newAct }, basedata ), [], env )

        NewCharSequenceMsg deliver ->
            ( initOne env (NewCharSequenceMsg deliver), [], env )

        VanishCharSequenceMsg ->
            ( ( { data | visible = False }, basedata ), [], env )

        CameraSequenceMsg act ->
            let
                newDes =
                    case act of
                        MoveLeft x ->
                            ( Tuple.first data.destination + x, Tuple.second data.destination )

                        MoveRight x ->
                            ( Tuple.first data.destination - x, Tuple.second data.destination )

                        MoveUp y ->
                            ( Tuple.first data.destination, Tuple.second data.destination + y )

                        MoveDown y ->
                            ( Tuple.first data.destination, Tuple.second data.destination - y )

                        Still ->
                            data.destination
            in
            ( ( { data | destination = newDes }, basedata ), [], env )

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
    if data.visible == True then
        let
            newSprite =
                --if not (data.action == Still) then
                data.movingSheet ++ "." ++ String.fromInt data.currentFrame

            -- else
            --     data.standingFigure --testing
        in
        ( Canvas.group
            []
            [ renderSprite env.globalData.internalData [] data.position ( 150, 0 ) newSprite
            ]
        , 53
        )

    else
        ( Canvas.empty, 53 )



-- z-index


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Character" ++ data.standingFigure ++ String.fromInt data.id


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
