module SceneProtos.Game.Components.Interface.Sequence exposing (Charactor, calculateApUp, checkSide, concatSelfEnemy, convertToCharactor, defaultChatactor, findIndex, getAt, getFirstChar, getQueue, getSequence, initUI, nextChar, renderQueue, sortCharByQueue)

{-|


# Sequence module

This module is used to generate the sequence of the characters in the game.

@docs Charactor, calculateApUp, checkSide, concatSelfEnemy, convertToCharactor, defaultChatactor, findIndex, getAt, getFirstChar, getQueue, getSequence, initUI, nextChar, renderQueue, sortCharByQueue

-}

import Canvas
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Lib.UserData exposing (UserData)
import Messenger.Base
import Messenger.Render.Sprite exposing (renderSprite)
import SceneProtos.Game.Components.ComponentBase exposing (ActionSide(..), BaseData, Gamestate(..))
import SceneProtos.Game.Components.Enemy.Init exposing (Enemy, defaultEnemy)
import SceneProtos.Game.Components.Interface.Init exposing (InitData)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Buff(..))
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


{-| The Charactor type alias
-}
type alias Charactor =
    { name : String
    , position : Int
    , ap : Int
    }


{-| The defaultChatactor
-}
defaultChatactor : Charactor
defaultChatactor =
    { name = ""
    , position = 0
    , ap = 0
    }


{-| The calculateApUp function
-}
calculateApUp : List ( Buff, Int ) -> Int
calculateApUp buff =
    List.sum <|
        List.map
            (\( b, _ ) ->
                case b of
                    SpeedUp value ->
                        value

                    SpeedDown value ->
                        -value

                    _ ->
                        0
            )
            buff


{-| The convertToCharactor function
-}
convertToCharactor : Self -> Enemy -> Bool -> Charactor
convertToCharactor self enemy flag =
    if flag then
        { name = self.name
        , position = self.position
        , ap = self.extendValues.actionPoints + calculateApUp self.buff
        }

    else
        { name = enemy.name
        , position = enemy.position
        , ap = enemy.extendValues.actionPoints + calculateApUp enemy.buff
        }


{-| The getSequence function
-}
getSequence : List Charactor -> List Charactor
getSequence data =
    data
        |> List.sortBy .ap
        |> List.reverse


{-| The concatSelfEnemy function
-}
concatSelfEnemy : List Self -> List Enemy -> List Charactor
concatSelfEnemy selfs enemies =
    let
        aliveSelfs =
            List.filter (\x -> x.hp /= 0) selfs

        aliveEnemies =
            List.filter (\x -> x.hp /= 0) enemies
    in
    List.map
        (\x -> convertToCharactor x defaultEnemy True)
        aliveSelfs
        ++ List.map
            (\x -> convertToCharactor defaultSelf x False)
            aliveEnemies


{-| The getQueue function
-}
getQueue : List Self -> List Enemy -> List Int
getQueue selfs enemies =
    List.map
        (\x -> x.position)
    <|
        getSequence <|
            concatSelfEnemy selfs enemies


{-| The getFirstChar function
-}
getFirstChar : List Int -> Int
getFirstChar queue =
    Maybe.withDefault 100 <|
        List.head <|
            queue


{-| The getAt function
-}
getAt : Int -> List a -> Maybe a
getAt index list =
    if index < 0 then
        Nothing

    else
        List.head (List.drop index list)


{-| The findIndex function
-}
findIndex : Int -> List Int -> Maybe Int
findIndex target list =
    List.head (List.indexedMap Tuple.pair list |> List.filter (\( _, value ) -> value == target) |> List.map Tuple.first)


{-| The nextChar function
-}
nextChar : InitData -> BaseData -> ( Int, Int, Bool )
nextChar initData basedata =
    let
        -- Get the index of curChar
        maybeIndex =
            findIndex basedata.curSelf initData.queue
    in
    case maybeIndex of
        Just index ->
            -- Calculate the next index
            let
                nextIndex =
                    index + 1
            in
            if nextIndex < List.length initData.queue then
                ( getAt nextIndex initData.queue |> Maybe.withDefault -1, nextIndex, False )

            else
                ( getFirstChar initData.queue, 0, True )

        -- or any other value indicating the end of the list
        Nothing ->
            if basedata.state == GameBegin then
                ( getFirstChar initData.queue, 0, True )

            else if initData.curIndex < List.length initData.queue then
                ( getAt initData.curIndex initData.queue |> Maybe.withDefault -1 |> Debug.log "result", initData.curIndex, False )

            else
                ( getFirstChar initData.queue, 0, True )


{-| The sortCharByQueue function
-}
sortCharByQueue : List Charactor -> List Int -> List String
sortCharByQueue data queue =
    List.map
        (\p ->
            .name <|
                Maybe.withDefault defaultChatactor <|
                    List.head <|
                        List.filter
                            (\c ->
                                c.position == p
                            )
                            data
        )
        queue


{-| The renderQueue function
-}
renderQueue : Messenger.Base.Env SceneCommonData UserData -> InitData -> List Canvas.Renderable
renderQueue env initData =
    let
        allChars =
            concatSelfEnemy initData.selfs initData.enemies

        sortedData =
            sortCharByQueue allChars initData.queue
    in
    List.map2
        (\x index ->
            renderSprite
                env.globalData.internalData
                [ imageSmoothing False ]
                ( 850 + index * 50, 600 )
                ( 50, 50 )
                (x ++ "Sheet.0/1")
        )
        sortedData
    <|
        List.map toFloat
            (List.range 0 (List.length sortedData - 1))


{-| The checkSide function
-}
checkSide : Int -> ActionSide
checkSide position =
    if 1 <= position && position <= 6 then
        PlayerSide

    else if 7 <= position && position <= 12 then
        EnemySide

    else
        Undeclaced


{-| The initUI function
-}
initUI : InitData -> BaseData -> ( InitData, BaseData )
initUI data basedata =
    let
        firstQueue =
            getQueue data.selfs data.enemies
    in
    ( { data | queue = firstQueue }, basedata )
