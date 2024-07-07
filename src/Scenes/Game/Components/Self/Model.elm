module Scenes.Game.Components.Self.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Canvas.Settings exposing (fill)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget, Gamestate(..), initBaseData)
import Scenes.Game.Components.Self.Init exposing (Self, State(..), defaultSelf)
import Scenes.Game.Components.Self.Reaction exposing (findMin, getHurt, getNewData, getTargetChar, handleAttack)
import Scenes.Game.Components.Self.UpdateHelper exposing (updateOne)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    List Self


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        SelfInit initData ->
            ( initData, initBaseData )

        _ ->
            ( [], initBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    let
        curChar =
            Maybe.withDefault { defaultSelf | id = 0 } <|
                List.head <|
                    List.filter (\x -> x.id == basedata.curChar) data

        ( ( newChar, newBasedata ), msg, ( newEnv, flag ) ) =
            updateOne env evnt curChar basedata

        newData =
            List.map
                (\x ->
                    if x.id == basedata.curChar then
                        newChar

                    else
                        x
                )
                data
    in
    ( ( newData, newBasedata ), msg, ( newEnv, flag ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        Attack attackType id ->
            handleAttack attackType id env msg data basedata

        ChangeTarget id ->
            ( ( data, { basedata | curEnemy = id } ), [], env )

        SwitchTurn ->
            ( ( data, { basedata | state = PlayerTurn } ), [], env )

        Defeated ->
            ( ( data, basedata ), [ Parent <| OtherMsg <| GameOver ], env )

        _ ->
            ( ( data, basedata ), [], env )


renderChar : Self -> Messenger.Base.Env SceneCommonData UserData -> Canvas.Renderable
renderChar char env =
    Canvas.group []
        [ renderSprite env.globalData.internalData [] ( char.x, char.y ) ( 100, 100 ) char.career
        , Canvas.shapes
            [ fill Color.red ]
            [ rect env.globalData.internalData ( char.x, char.y ) ( 100 * (char.hp / 100), 5 ) ]
        ]


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        basicView =
            List.map
                (\x -> renderChar x env)
                data
    in
    ( Canvas.group []
        basicView
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
