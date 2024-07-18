module Scenes.Game.Components.Self.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (empty)
import Canvas.Settings exposing (fill, stroke)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), StatusMsg(..), ComponentTarget, Gamestate(..), initBaseData, InitMsg(..), ActionMsg(..))
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.Components.Self.AttackRec exposing (findMin, getHurt, handleAttack)
import Scenes.Game.Components.Self.UpdateOne exposing (updateOne)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Self


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        Init (SelfInit initData) ->
            ( initData, initBaseData )

        _ ->
            ( [], initBaseData )


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


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        posChanged =
            posExchange evnt data basedata

        msgPos =
            [ Other ( "Interface", UpdateChangingPos posChanged ) ]

        curChar =
            if basedata.state /= GameBegin then
                if 0 < basedata.curChar && basedata.curChar <= 6 then
                    Maybe.withDefault { defaultSelf | position = 0 } <|
                        List.head <|
                            List.filter (\x -> x.position == basedata.curChar && x.hp /= 0) posChanged

                else
                    { defaultSelf | position = -1 }

            else
                defaultSelf

        ( ( newChar, newBasedata ), msg, ( newEnv, flag ) ) =
            updateOne posChanged env evnt curChar basedata

        newData =
            if basedata.state /= GameBegin then
                List.map
                    (\x ->
                        if x.position == basedata.curChar && x.hp /= 0 then
                            newChar

                        else
                            x
                    )
                    posChanged

            else
                posChanged

        interfaceMsg =
            [ Other ( "Interface", ChangeStatus (ChangeSelfs newData) )
            , Other ( "Interface", ChangeStatus (ChangeBase newBasedata) )
            ]
    in
    ( ( newData, newBasedata ), msgPos ++ interfaceMsg ++ msg, ( newEnv, flag ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        Action (EnemyNormal enemy position isCounter) ->
            handleAttack enemy position env msg data basedata

        CharDie length ->
            ( ( data, { basedata | enemyNum = length } ), [], env )

        SwitchTurn pos ->
            ( ( data, { basedata | state = PlayerTurn, curChar = pos } ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver, Other ( "Interface", ChangeStatus (ChangeSelfs data) ) ], env )

        _ ->
            ( ( data, basedata ), [], env )


renderChar : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderChar char env =
    if char.hp /= 0 then
        renderSprite env.globalData.internalData [] ( char.x, char.y ) ( 100, 100 ) char.name

    else
        empty


renderRegion : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderRegion char env =
    let
        color =
            if char.state == Waiting then
                Color.black

            else
                Color.green
    in
    Canvas.shapes
        [ stroke color ]
        [ rect env.globalData.internalData ( char.x - 5, char.y - 5 ) ( 110, 110 ) ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        basicView =
            List.map
                (\x -> renderChar x env)
                data

        regionView =
            if basedata.state == GameBegin then
                List.map
                    (\x -> renderRegion x env)
                    data

            else
                [ empty ]
    in
    ( Canvas.group []
        (regionView ++ basicView)
    , 1
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Self"


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Component generator
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
