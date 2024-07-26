module SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (..)


updateHelper : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateHelper env evnt data basedata =
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
