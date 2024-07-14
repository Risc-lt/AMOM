module Scenes.Game.Components.Self.Sequence exposing (..)

import Canvas
import Lib.UserData exposing (UserData)
import Messenger.Base
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.Interface.RenderHelper exposing (renderStatus)
import Scenes.Game.Components.Self.GetBasicValue exposing (genActionPoints)
import Scenes.Game.Components.Self.Init exposing (Self)
import Scenes.Game.SceneBase exposing (SceneCommonData)


getSequence : List Self -> Messenger.Base.Env SceneCommonData UserData -> List Self
getSequence data env =
    data
        |> List.filter (\x -> x.hp /= 0)
        |> List.sortBy (\x -> genActionPoints x env)
        |> List.reverse


getQueue : List Self -> Messenger.Base.Env SceneCommonData UserData -> List Int
getQueue data env =
    List.map
        (\x -> x.position)
        (getSequence data env)


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
    List.head (List.indexedMap Tuple.pair list |> List.filter (\( index, value ) -> value == target) |> List.map Tuple.first)



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
                -1

        -- or any other value indicating the end of the list
        Nothing ->
            -1


sortCharByQueue : List Self -> List Int -> List Self
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
        |> List.filter (\x -> x.hp /= 0)
        |> List.reverse


renderQueue : Messenger.Base.Env SceneCommonData UserData -> List Self -> List Int -> List Canvas.Renderable
renderQueue env data queue =
    let
        sortedData =
            sortCharByQueue data queue
    in
    List.map2
        (\x index -> renderSprite env.globalData.internalData [] ( 1470 + index * 100, 900 ) ( 100, 100 ) x.career)
        sortedData
    <|
        List.map toFloat
            (List.range 0 (List.length sortedData - 1))
