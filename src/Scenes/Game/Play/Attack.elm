module Scenes.Game.Play.Attack exposing (judgeAttack)

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent)
import Messenger.GeneralModel exposing (unroll)
import Scenes.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Game.SceneBase exposing (SceneCommonData)


type alias GameComponent =
    AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg


judgeAttack : List GameComponent -> List ( ComponentTarget, ComponentMsg )
judgeAttack xs =
    case xs of
        enemy :: self :: _ ->
            judgeHelper enemy self

        _ ->
            Debug.todo "judgeCollision: not enough components"


judgeHelper : GameComponent -> GameComponent -> List ( ComponentTarget, ComponentMsg )
judgeHelper enemy self =
    let
        realEnemyHP =
            (unroll enemy).baseData.enemyHP

        realSelfData =
            (unroll self).baseData.selfHP
    in
    if realEnemyHP <= 0 then
        [ ( "Enemy", Defeated ) ]

    else if realSelfData <= 0 then
        [ ( "Self", Defeated ) ]

    else
        []