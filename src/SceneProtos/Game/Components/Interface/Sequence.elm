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
import Scenes.Game.Components.Special.Init exposing (Buff(..))
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
    let
        apUp =
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
                    self.buff
    in
    { name = self.name
    , position = self.position
    , ap = self.extendValues.actionPoints + apUp
    }


convertEnemyToCharactor : Enemy -> Charactor
convertEnemyToCharactor enemy =
    let
        apUp =
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
                    enemy.buff
    in
    { name = enemy.name
    , position = enemy.position
    , ap = enemy.extendValues.actionPoints + apUp
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
                ( getAt initData.curIndex initData.queue |> Maybe.withDefault -1, initData.curIndex, False )

            else
                ( getFirstChar initData.queue, 0, True )


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


renderQueue : Messenger.Base.Env SceneCommonData UserData -> InitData -> List Canvas.Renderable
renderQueue env initData =
    let
        allChars =
            concatSelfEnemy initData.selfs initData.enemies

        sortedData =
            sortCharByQueue allChars initData.queue
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
    in
    ( { data | queue = firstQueue }, basedata )
