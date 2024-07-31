module SceneProtos.Game.Components.Self.PosExchange exposing
    ( posExchange
    , selection
    )

import Messenger.Base exposing (UserEvent(..))
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import SceneProtos.Game.Components.ComponentBase exposing (ActionMsg(..), ActionSide(..), BaseData, ComponentMsg(..), Gamestate(..), InitMsg(..), StatusMsg(..))
import SceneProtos.Game.Components.Self.Init exposing (Self, State(..))


{-| The initial data for the StroryTrigger component
-}
type alias Data =
    List Self


{-| The initial data for the StroryTrigger component
-}
selection : Float -> Float -> Self -> Self
selection x y data =
    if x > data.x - 5 && x < data.x + 105 && y > data.y - 5 && y < data.y + 105 then
        if data.state /= Working then
            { data | state = Working }

        else if data.state == Working then
            { data | state = Waiting }

        else
            data

    else
        data


{-| The initial data for the StroryTrigger component
-}
posExchange : UserEvent -> Data -> BaseData -> Data
posExchange evnt data basedata =
    if basedata.state == GameBegin then
        case evnt of
            MouseUp key ( x, y ) ->
                let
                    newData =
                        if key == 0 then
                            List.map
                                (\s ->
                                    selection x y s
                                )
                                data

                        else
                            data

                    targets =
                        List.filter (\s -> s.state == Working) newData

                    rest =
                        List.filter (\s -> s.state /= Working) newData

                    reTargets =
                        List.reverse targets

                    newTargets =
                        if List.length targets == 2 then
                            List.map2
                                (\o ->
                                    \n ->
                                        { n | x = o.x, y = o.y, position = o.position, state = Waiting }
                                )
                                targets
                                reTargets

                        else
                            targets
                in
                newTargets ++ rest

            _ ->
                data

    else
        data
