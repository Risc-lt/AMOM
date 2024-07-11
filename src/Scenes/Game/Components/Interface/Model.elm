module Scenes.Game.Components.Interface.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (Renderable, empty, lineTo, path)
import Canvas.Settings exposing (fill, stroke)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Coordinate.Coordinates exposing (posToReal)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter, renderTextWithColorStyle)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import Scenes.Game.Components.Interface.Init exposing (Chars, InitData, defaultUI)
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        UIInit initData ->
            ( initData, initBaseData )

        _ ->
            ( defaultUI, initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        ChangeSelfs list ->
            ( ( { data | selfs = list }, basedata ), [], env )

        ChangeEnemies list ->
            ( ( { data | enemies = list }, basedata ), [], env )

        SwitchTurn ->
            ( ( data, { basedata | state = PlayerTurn } ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


getName : String -> String
getName career =
    case career of
        "swordsman" ->
            "Wenderd"

        "archer" ->
            "Bruce"

        "magician" ->
            "Bulingze"

        "pharmacist" ->
            "Bithif"

        _ ->
            ""


renderStatus : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderStatus self env =
    let
        name =
            getName self.career

        y =
            case self.career of
                "swordsman" ->
                    40

                "archer" ->
                    250

                "magician" ->
                    460

                "pharmacist" ->
                    670

                _ ->
                    0

        color =
            if self.hp == 0 then
                Color.red

            else
                Color.black
    in
    if self.career /= "" then
        Canvas.group []
            [ renderSprite env.globalData.internalData [] ( 1470, y ) ( 160, 160 ) self.career
            , Canvas.shapes
                [ fill Color.red ]
                [ rect env.globalData.internalData ( 1650, y + 57.5 ) ( 200 * (self.hp / 100), 15 ) ]
            , Canvas.shapes
                [ stroke Color.black ]
                [ rect env.globalData.internalData ( 1650, y + 57.5 ) ( 200, 15 ) ]
            , renderTextWithColorStyle env.globalData.internalData 20 name "Arial" color "" ( 1650, y + 27.5 )
            ]

    else
        empty


renderChangePosition : Env cdata userdata -> Data -> BaseData -> Renderable
renderChangePosition env data basedata =
    if basedata.state == GameBegin then
        let
            working =
                List.filter
                    (\x ->
                        x.state == Working
                    )
                    data.selfs

            target =
                if List.length working == 1 then
                    Maybe.withDefault defaultSelf (List.head working)

                else
                    defaultSelf

            name =
                if target.career /= "" then
                    getName target.career ++ " chosen"

                else
                    "Nobody chosen"
        in
        Canvas.group []
            [ renderTextWithColorCenter env.globalData.internalData 60 "Positon" "Arial" Color.black ( 160, 830 )
            , renderTextWithColorCenter env.globalData.internalData 60 "Changing" "Arial" Color.black ( 160, 950 )
            , renderTextWithColorCenter env.globalData.internalData 60 name "Arial" Color.black ( 870, 880 )
            ]

    else
        empty


renderAction : Env cdata userdata -> Data -> BaseData -> Renderable
renderAction env data basedata =
    Canvas.group []
        [ Canvas.shapes
            [ stroke Color.black ]
            [ path (posToReal env.globalData.internalData ( 320, 680 )) [ lineTo (posToReal env.globalData.internalData ( 320, 1080 )) ] ]
        , renderChangePosition env data basedata
        ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        statusView =
            List.map
                (\x ->
                    renderStatus x env
                )
                data.selfs

        actionView =
            renderAction env data basedata
    in
    ( Canvas.group []
        (actionView :: statusView)
    , 2
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Interface"


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
