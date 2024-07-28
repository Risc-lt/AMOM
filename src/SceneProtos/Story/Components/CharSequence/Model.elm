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
import SceneProtos.Story.Components.CharSequence.Init exposing (Character, InitData, MoveKind(..), Movement, defaultCharacter, defaultMovement)
import SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (..)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, initBaseData)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


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
                nextMove =
                    List.map
                        (\m ->
                            { m | isMoving = True }
                        )
                    <|
                        List.filter (\m -> m.id == id) data.remainMove

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
                                        Real _ speed ->
                                            { c | posture = movement.posture, speed = speed, isMoving = True }

                                        Follow _ speed ->
                                            { c | posture = movement.posture, speed = speed, isMoving = True }

                                        Fake _ ->
                                            { c | posture = movement.posture, isMoving = True }

                                        None ->
                                            { c | posture = movement.posture, isMoving = False }

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
                , [ Other ( "Trigger", BeginPlot 2 ) ]
                , env
                )

            else
                ( ( data, basedata ), [], env )

        EndMove ->
            let
                newMove =
                    List.map
                        (\m ->
                            case m.movekind of
                                Fake _ ->
                                    { m | isMoving = False }

                                _ ->
                                    m
                        )
                        data.curMove

                newChars =
                    List.map
                        (\c ->
                            case
                                List.head <|
                                    List.filter (\n -> n.name == c.name) <|
                                        newMove
                            of
                                Just movement ->
                                    case movement.movekind of
                                        Fake _ ->
                                            { c | isMoving = False }

                                        _ ->
                                            c

                                _ ->
                                    c
                        )
                        data.characters
            in
            ( ( { data | characters = newChars, curMove = newMove }, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( Canvas.group [] <|
        List.map
            (\c ->
                renderSprite env.globalData.internalData [] ( c.x, c.y ) ( 140, 0 ) c.name
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
