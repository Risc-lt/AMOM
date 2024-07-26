module SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (..)


import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..))
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.CharSequence.Init exposing (InitData, Character, Movement)
import SceneProtos.Story.Components.CharSequence.Init exposing (defaultCharacter)


type alias Data =
    InitData


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


updateHelper : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateHelper env _ data basedata =
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

        newState =
            List.any (\m -> m.isMoving == True) newMoves
    in
    ( ( { data | characters = newChars, curMove = newMoves }, { basedata | isPlaying = not newState } )
    , []
    , ( env, False ) )
