module Scenes.Game.Components.Enemy.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Render.Sprite exposing (renderSprite)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Game.Components.Enemy.Init exposing (Enemy)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    Enemy


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        EnemyInit initData ->
            ( initData, () )

        _ ->
            ( { x = 100, y = 100, hp = 100, id = 1 }, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( renderSprite env.globalData.internalData [] ( data.x, data.y ) ( 100, 100 ) "uglyman"
    , 1
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Enemy"


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
