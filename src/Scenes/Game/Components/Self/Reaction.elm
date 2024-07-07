module Scenes.Game.Components.Self.Reaction exposing (..)

import Messenger.Base exposing (UserEvent(..))
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), ComponentMsg(..), Gamestate(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)


checkHealth : Self -> Self
checkHealth char =
    if char.hp <= 0 then
        { char | state = Dead }

    else
        char


getHurt : AttackType -> Self -> Self
getHurt attackType char =
    case attackType of
        Physical ->
            checkHealth <|
                { char | hp = char.hp - 50 * (100 - char.phyDefence) / 100 }

        Magical ->
            checkHealth <|
                { char | hp = char.hp - 50 * (100 - char.magDefence) / 100 }


getTargetChar : List Self -> Int -> Self
getTargetChar data id =
    Maybe.withDefault { defaultSelf | id = 0 } <|
        List.head <|
            List.filter (\x -> x.id == id) data


getNewData : List Self -> Self -> List Self
getNewData data newChar =
    List.filter
        (\x -> x.state /= Dead)
    <|
        List.map
            (\x ->
                if x.id == newChar.id then
                    newChar

                else
                    x
            )
            data


findMin : List Self -> Int
findMin data =
    data
        |> List.map (\x -> x.id)
        |> List.sort
        |> List.head
        |> Maybe.withDefault 100
