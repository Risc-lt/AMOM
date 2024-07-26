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
import SceneProtos.Story.Components.Background.UpdateHelper exposing (updateHelper)


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
    case evnt of
        Tick _ ->
            if basedata.isPlaying == True then
                updateHelper env evnt data basedata

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        BeginPlot id ->
            let
                maybeNextMove =
                    List.head <|
                        List.filter (\m -> m.id == id) data.remainMove

                nextMove =
                    case maybeNextMove of
                        Just move ->
                            { move | isMoving = True }
                        
                        _ ->
                            data.curMove

                remainMove =
                    List.filter (\m -> m.id /= id) data.remainMove
            in
            if nextMove.isMoving == True then
                ( ( { data
                        | curMove = nextMove
                        , remainMove = remainMove
                    }
                , { basedata | isPlaying = True }
                )
                , []
                , env
                )

            else
                ( ( data, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


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
