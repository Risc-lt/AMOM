module Scenes.Game.Components.Interface.Sequence exposing (..)

import Canvas
import Lib.UserData exposing (UserData)
import Messenger.Base
import Messenger.Component.GlobalComponent exposing (filterAliveGC)
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.ComponentBase exposing (ActionSide(..), BaseData, Gamestate(..))
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.Components.Interface.Init exposing (InitData)
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Charactor =
    { name : String
    , position : Int
    , ap : Int
    }


defaultChatactor : Charactor
defaultChatactor =
    { name = ""
    , position = 0
    , ap = 0
    }


convertSelfToCharactor : Self -> Charactor
convertSelfToCharactor self =
    { name = self.name
    , position = self.position
    , ap = self.extendValues.actionPoints
    }


convertEnemyToCharactor : Enemy -> Charactor
convertEnemyToCharactor enemy =
    { name = enemy.name
    , position = enemy.position
    , ap = enemy.extendValues.actionPoints
    }


getSequence : List Charactor -> List Charactor
getSequence data =
    data
        |> List.sortBy .ap
        |> List.reverse


concatSelfEnemy : List Self -> List Enemy -> List Charactor
concatSelfEnemy selfs enemies =
    let
        aliveSelfs =
            List.filter (\x -> x.hp /= 0) selfs

        aliveEnemies =
            List.filter (\x -> x.hp /= 0) enemies
    in
    List.map
        (\x -> convertSelfToCharactor x)
        aliveSelfs
        ++ List.map
            (\x -> convertEnemyToCharactor x)
            aliveEnemies


getQueue : List Self -> List Enemy -> List Int
getQueue selfs enemies =
    List.map
        (\x -> x.position)
    <|
        getSequence <|
            concatSelfEnemy selfs enemies


getFirstChar : List Int -> Int
getFirstChar queue =
    Maybe.withDefault 100 <|
        List.head <|
            queue



-- Helper function to get the element at a specific index in the list


getAt : Int -> List a -> Maybe a
getAt index list =
    if index < 0 then
        Nothing

    else
        List.head (List.drop index list)



-- Helper function to find the index of an element in the list


findIndex : Int -> List Int -> Maybe Int
findIndex target list =
    List.head (List.indexedMap Tuple.pair list |> List.filter (\( _, value ) -> value == target) |> List.map Tuple.first)



-- The nextChar function


nextChar : List Int -> Int -> Int
nextChar queue curChar =
    let
        -- Get the index of curChar
        maybeIndex =
            findIndex curChar queue
    in
    case maybeIndex of
        Just index ->
            -- Calculate the next index
            let
                nextIndex =
                    index + 1
            in
            if nextIndex < List.length queue then
                getAt nextIndex queue |> Maybe.withDefault -1

            else
                getFirstChar queue

        -- or any other value indicating the end of the list
        Nothing ->
            -1


nextSelf : List Int -> Int -> Int
nextSelf queue curChar =
    let
        nextPos =
            nextChar queue curChar
    in
    if 1 <= nextPos && nextPos <= 6 then
        nextPos

    else
        nextSelf queue nextPos


nextEnemy : List Int -> Int -> Int
nextEnemy queue curChar =
    let
        nextPos =
            nextChar queue curChar
    in
    if 7 <= nextPos && nextPos <= 12 then
        nextPos

    else
        nextEnemy queue nextPos


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


renderQueue : Messenger.Base.Env SceneCommonData UserData -> List Self -> List Enemy -> List Canvas.Renderable
renderQueue env selfs enemies =
    let
        allChars =
            concatSelfEnemy selfs enemies

        queue =
            getQueue selfs enemies

        sortedData =
            sortCharByQueue allChars queue
    in
    List.map2
        (\x index -> renderSprite env.globalData.internalData [] ( 900 + index * 50, 600 ) ( 50, 50 ) x)
        sortedData
    <|
        List.map toFloat
            (List.range 0 (List.length sortedData - 1))


checkSide : Int -> ActionSide
checkSide position =
    if 1 <= position && position <= 6 then
        PlayerSide

    else if 7 <= position && position <= 12 then
        EnemySide

    else
        Undeclaced


initUI : InitData -> BaseData -> ( InitData, BaseData )
initUI data basedata =
    let
        firstQueue =
            getQueue data.selfs data.enemies

        firstChar =
            getFirstChar firstQueue

        firstSide =
            checkSide firstChar
    in
    ( data, { basedata | queue = firstQueue, side = firstSide, curSelf = firstChar } )
