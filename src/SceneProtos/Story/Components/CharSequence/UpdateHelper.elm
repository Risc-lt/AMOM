module SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (..)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..))
import SceneProtos.Story.Components.CharSequence.Init exposing (Character, Direction(..), InitData, MoveKind(..), Movement, defaultCharacter)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


changePosition : Float -> Float -> Character -> Character
changePosition targetX targetY character =
    case character.direction of
        Right ->
            if character.x + character.speed > targetX then
                { character | x = targetX }

            else
                { character | x = character.x + character.speed }

        Left ->
            if character.x - character.speed < targetX then
                { character | x = targetX }

            else
                { character | x = character.x - character.speed }

        Down ->
            if character.y + character.speed > targetY then
                { character | y = targetY }

            else
                { character | y = character.y + character.speed }

        Up ->
            if character.y - character.speed < targetY then
                { character | y = targetY }

            else
                { character | y = character.y - character.speed }


changeDirection : ( Movement, Character ) -> ( Movement, Character )
changeDirection ( movement, character ) =
    case movement.movekind of
        Real ( targetX, targetY ) _ ->
            if targetX > character.x then
                ( movement, { character | direction = Right } )

            else if targetX < character.x then
                ( movement, { character | direction = Left } )

            else if targetY > character.y then
                ( movement, { character | direction = Down } )

            else if targetY < character.y then
                ( movement, { character | direction = Up } )

            else
                ( movement, character )

        Follow ( targetX, targetY ) _ ->
            if targetX > character.x then
                ( movement, { character | direction = Right } )

            else if targetX < character.x then
                ( movement, { character | direction = Left } )

            else if targetY > character.y then
                ( movement, { character | direction = Down } )

            else if targetY < character.y then
                ( movement, { character | direction = Up } )

            else
                ( movement, character )

        Fake direction ->
            ( movement, { character | direction = direction } )

        None direction ->
            ( movement, { character | direction = direction } )


handleMove : ( Movement, Character ) -> ( Movement, Character )
handleMove ( movement, character ) =
    case movement.movekind of
        Real ( targetX, targetY ) _ ->
            ( movement, changePosition targetX targetY character )

        Follow ( targetX, targetY ) _ ->
            ( movement, changePosition targetX targetY character )

        _ ->
            ( movement, character )


checkDestination : ( Movement, Character ) -> ( Movement, Character )
checkDestination ( movement, character ) =
    case movement.movekind of
        Real ( targetX, targetY ) _ ->
            if character.x == targetX && character.y == targetY then
                ( { movement | isMoving = False }, { character | isMoving = False } )

            else
                ( movement, character )

        Follow ( targetX, targetY ) _ ->
            if character.x == targetX && character.y == targetY then
                ( { movement | isMoving = False }, character )

            else
                ( movement, character )

        None _ ->
            ( { movement | isMoving = False }, character )

        _ ->
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
            <|
                List.filter (\m -> m.isMoving == True) data.curMove

        newPlots =
            List.map
                (\( m, c ) ->
                    checkDestination <| handleMove <| changeDirection ( m, c )
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
                        Just character ->
                            character

                        _ ->
                            c
                )
                data.characters

        newState =
            List.all (\m -> m.isMoving == False) newMoves

        newMsg =
            if newState then
                [ Other ( "Trigger", PlotDone 2 ) ]

            else
                []
    in
    ( ( { data | characters = newChars, curMove = newMoves }, { basedata | isPlaying = not newState } )
    , newMsg
    , ( env, False )
    )
