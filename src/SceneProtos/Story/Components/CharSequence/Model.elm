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
import SceneProtos.Story.Components.CharSequence.Init exposing (defaultCharacter)
import SceneProtos.Story.Components.CharSequence.Init exposing (defaultMovement)


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


handleMove : ( Movement, Character ) -> ( Movement, Character )
handleMove ( movement, character ) =
    if movement.targetX > character.x then
        if character.x + movement.speed > movement.targetX then
            ( movement, { character | x = movement.targetX } )

        else
            ( movement, { character | x = character.x + movement.speed } )

    else if movement.targetX < character.x then
        if character.x - movement.speed < movement.targetX then
            ( movement, { character | x = movement.targetX } )

        else
            ( movement, { character | x = character.x - movement.speed } )

    else if movement.targetY > character.y then
        if character.y + movement.speed > movement.targetY then
            ( movement, { character | y = movement.targetY } )

        else
            ( movement, { character | y = character.y + movement.speed } )

    else if movement.targetY < character.y then
        if character.y - movement.speed < movement.targetY then
            ( movement, { character | y = movement.targetY } )

        else
            ( movement, { character | y = character.y - movement.speed } )

    else
        ( movement, character )


checkDestination : ( Movement, Character ) -> ( Movement, Character )
checkDestination ( movement, character ) =
    if character.x == movement.targetX && character.y == movement.targetY then
        ( { movement | isMoving = False }, character )

    else
        ( movement, character )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick _ ->
            if basedata.isPlaying == True then
                let
                    curPlots =
                        List.map 
                            (\m -> 
                                Tuple.pair m <|
                                    Maybe.withDefault defaultCharacter <|
                                        List.head <|
                                            List.filter (\c -> c.name == m.name) data.characters
                            )
                            <| List.filter (\m -> m.isMoving == True) data.curMove

                    newPlots =
                        List.map 
                            (\( m, c ) ->
                                checkDestination <| handleMove ( m, c )
                            )
                            curPlots

                    newMoves =
                        List.map
                            (\m ->
                                case
                                    List.head <|
                                        List.filter (\n -> n.name == m.name) <|
                                            List.map Tuple.first newPlots
                                of
                                    Just movement ->
                                        movement

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
                                            List.map Tuple.second newPlots
                                of
                                    Just movement ->
                                        movement

                                    _ ->
                                        c
                            )
                            data.characters
                in
                ( ( { data | characters = newChars, curMove = newMoves }, basedata )
                , []
                , ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
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
    if data.visible then
        let
            newSprite =
                "Bithif"

            --    data.standingFigure
            --if not (data.action == Still) then
            --data.movingSheet ++ "." ++ String.fromInt data.currentFrame
            -- else
            --     data.standingFigure --testing
            -- _ =
            --     Debug.log "newSprite" newSprite
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
