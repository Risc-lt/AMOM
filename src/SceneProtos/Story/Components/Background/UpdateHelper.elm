module SceneProtos.Story.Components.Background.UpdateHelper exposing (..)


import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..))
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.Background.Init exposing (InitData, Background, Camera)
import SceneProtos.Story.Components.Background.Init exposing (defaultCamera)


type alias Data =
    InitData


bySelfMove : Float -> Float -> Float -> Background -> Background
bySelfMove targetX targetY speed background =
    if targetX > background.x then
        if background.x + speed > targetX then
            { background | x = targetX }

        else
            { background | x = background.x + speed }

    else if targetX < background.x then
        if background.x - speed < targetX then
            { background | x = targetX }

        else
            { background | x = background.x - speed }

    else if targetY > background.y then
        if background.y + speed > targetY then
            { background | y = targetY }

        else
            { background | y = background.y + speed }

    else if targetY < background.y then
        if background.y - speed < targetY then
            { background | y = targetY }

        else
            { background | y = background.y - speed }

    else
        background


checkDestination : Float -> Float -> Background -> Bool
checkDestination targetX targetY background =
    if background.x == targetX && background.y == targetY then
        True

    else
        False


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
