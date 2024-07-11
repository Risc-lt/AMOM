module Scenes.Game.Components.Interface.Model exposing (component)

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
import Messenger.Render.Text exposing (renderTextWithColorStyle)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, StatusChange(..), initBaseData)
import Scenes.Game.Components.Interface.Init exposing (Chars, InitData, Type(..), defaultChars, defaultUI)
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
        ChangeStatus ( position, Hp newHp ) ->
            let
                target =
                    Maybe.withDefault defaultChars <|
                        List.head <|
                            List.filter
                                (\x ->
                                    x.position == position && x.side == Self
                                )
                                data.chars

                newTarget =
                    { target | hp = newHp }

                newChars =
                    List.map
                        (\x ->
                            if x.position == position then
                                newTarget

                            else
                                x
                        )
                        data.chars
            in
            ( ( { chars = newChars }, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


renderChar : Chars -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderChar char env =
    let
        ( career, y ) =
            case char.name of
                "Wenderd" ->
                    ( "swordsman", 40 )

                "Bruce" ->
                    ( "archer", 250 )

                "Bulingze" ->
                    ( "magician", 460 )

                "Bithif" ->
                    ( "pharmacist", 670 )

                _ ->
                    ( "", 0 )

        color =
            if char.hp == 0 then
                Color.red

            else
                Color.black
    in
    if char.side == Self then
        Canvas.group []
            [ renderSprite env.globalData.internalData [] ( 1470, y ) ( 160, 160 ) career
            , Canvas.shapes
                [ fill Color.red ]
                [ rect env.globalData.internalData ( 1650, y + 57.5 ) ( 200 * (char.hp / 100), 15 ) ]
            , renderTextWithColorStyle env.globalData.internalData 20 char.name "Arial" color "" ( 1650, y + 27.5 )
            ]

    else
        empty


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        statusView =
            List.map
                (\x ->
                    renderChar x env
                )
                data.chars
    in
    ( Canvas.group []
        statusView
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
