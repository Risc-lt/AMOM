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
    , agility : Float
    }


convertSelfToCharactor : Self -> Charactor
convertSelfToCharactor self =
    { name = self.career
    , position = self.position
    , agility = self.attributes.agility
    }


convertEnemyToCharactor : Enemy -> Charactor
convertEnemyToCharactor enemy =
    { name = "monster"
    , position = enemy.position
    , agility = enemy.attributes.agility
    }


genActionPoints : Charactor -> Messenger.Base.Env SceneCommonData UserData -> Float
genActionPoints char env =
    -- let
    --     upperBound =
    --         char.attributes.agility
    -- in
    -- genRandomNum 1 upperBound env
    char.agility


getSequence : Messenger.Base.Env SceneCommonData UserData -> List Charactor -> List Charactor
getSequence env data =
    data
        |> List.sortBy .position
        |> List.reverse
        |> List.sortBy (\x -> genActionPoints x env)
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


getQueue : List Self -> List Enemy -> Messenger.Base.Env SceneCommonData UserData -> List Int
getQueue selfs enemies env =
    List.map
        (\x -> x.position)
    <|
        getSequence env <|
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


sortCharByQueue : List Charactor -> List Int -> List Charactor
sortCharByQueue data queue =
    List.map
        (\x ->
            case findIndex x.position queue of
                Just index ->
                    ( index, x )

                Nothing ->
                    ( 100, x )
        )
        data
        |> List.sortBy Tuple.first
        |> List.map Tuple.second


renderQueue : Messenger.Base.Env SceneCommonData UserData -> List Self -> List Enemy -> List Canvas.Renderable
renderQueue env selfs enemies =
    let
        allChars =
            concatSelfEnemy selfs enemies

        queue =
            getQueue selfs enemies env

        sortedData =
            sortCharByQueue allChars queue
    in
    List.map2
        (\x index -> renderSprite env.globalData.internalData [] ( 900 + index * 50, 600 ) ( 50, 50 ) x.name)
        sortedData
    <|
        List.map toFloat
            (List.range 0 (List.length sortedData - 1))


checkSide : Int -> ActionSide
checkSide char =
    if 1 <= char && char <= 6 then
        PlayerSide

    else if 7 <= char && char <= 12 then
        EnemySide

    else
        Undeclaced


initUI : Messenger.Base.Env SceneCommonData UserData -> InitData -> BaseData -> ( InitData, BaseData )
initUI env data basedata =
    let
        firstQueue =
            getQueue data.selfs data.enemies env

        firstChar =
            getFirstChar firstQueue

        firstSide =
            checkSide firstChar
    in
    ( { data | charPointer = firstChar }, { basedata | queue = firstQueue, side = firstSide } )
