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
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.CharSequence.Init exposing (InitData, Character, Movement)
import SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (..)
import SceneProtos.Story.Components.CharSequence.Init exposing (defaultMovement)
import SceneProtos.Story.Components.CharSequence.Init exposing (defaultCharacter)
import SceneProtos.Story.Components.CharSequence.Init exposing (MoveKind(..))


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        CharInit deliver ->
            ( deliver, initBaseData )

        _ ->
            ( { characters = []
              , curMove = []
              , remainMove = []
              }
            , initBaseData
            )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            if basedata.isPlaying == True then
                let
                    ( ( newData, newBasedata ), newMsg, ( newEnv, newBlock ) ) =
                        updateHelper env evnt data basedata
                in
                ( ( newData, newBasedata )
                , Other ( "Background", ChangeChars newData.characters ) :: newMsg
                , ( newEnv, newBlock ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        BeginPlot id ->
            let
                nextMove =
                    List.map 
                        (\m ->
                            { m | isMoving = True }
                        )
                        <| List.filter (\m -> m.id == id) data.remainMove

                remainMove =
                    List.filter (\m -> m.id /= id) data.remainMove

                newChars =
                    List.map
                        (\c ->
                            case
                                List.head <|
                                    List.filter (\n -> n.name == c.name) <|
                                        nextMove
                            of
                                Just movement ->
                                    case movement.movekind of 
                                        Real ( _, _ ) speed ->
                                            { c | speed = speed }

                                        _ ->
                                            c

                                _ ->
                                    c
                        )
                        data.characters
            in
            if List.length nextMove /= 0 then
                ( ( { data
                        | characters = newChars
                        , curMove = nextMove
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
    ( Canvas.group [] <|
        List.map
            (\c ->
                renderSprite env.globalData.internalData [] ( c.x, c.y ) ( 100, 0 ) c.name
            )
            data.characters
    , 2
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Character"


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
