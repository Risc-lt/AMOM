module Scenes.Game.Components.Self.Reaction exposing (..)

import Messenger.Base exposing (UserEvent(..))
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Scenes.Game.Components.ComponentBase exposing (AttackType(..), ComponentMsg(..), Gamestate(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)


getHurt : AttackType -> Self -> Self
getHurt attackType char =
    case attackType of
        Physical ->
            { char | hp = char.hp - 50 * (100 - char.phyDefence) / 100 }

        Magical ->
            { char | hp = char.hp - 50 * (100 - char.magDefence) / 100 }


getTargetChar : List Self -> Int -> Self
getTargetChar data id =
    Maybe.withDefault { defaultSelf | id = 0 } <|
        List.head <|
            List.filter (\x -> x.id == id) data


getNewData : List Self -> Self -> List Self
getNewData data newChar =
    List.map
        (\x ->
            if x.id == newChar.id then
                newChar

            else
                x
        )
        data
