module SceneProtos.Story.Components.Background.UpdateHelper exposing (updateHelper)

{-|


# Background Update Helper

This module is used to update the background component.

@docs updateHelper

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate, ComponentUpdateRec)
import Messenger.GeneralModel exposing (Msg(..))
import SceneProtos.Story.Components.Background.Init exposing (Background, Camera, InitData, defaultCamera)
import SceneProtos.Story.Components.CharSequence.Init exposing (Character, defaultCharacter)
import SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (checkDestination)
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)


type alias Data =
    InitData


bySelfMove : Float -> Float -> Float -> Background -> Background
bySelfMove targetX targetY speed background =
    if targetX > background.x then
        if background.x + speed > targetX then
            { background | x = targetX }

        else
            { background | x = background.x + speed }

    else if targetX < background.x then
        if background.x - speed < targetX then
            { background | x = targetX }

        else
            { background | x = background.x - speed }

    else if targetY > background.y then
        if background.y + speed > targetY then
            { background | y = targetY }

        else
            { background | y = background.y + speed }

    else if targetY < background.y then
        if background.y - speed < targetY then
            { background | y = targetY }

        else
            { background | y = background.y - speed }

    else
        background


checkDestination : Camera -> Background -> Camera
checkDestination camera background =
    if background.x == camera.targetX && background.y == camera.targetY then
        { camera | isMoving = False }

    else
        camera


updateHelper : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateHelper env _ data basedata =
    let
        newBack =
            bySelfMove
                data.curMove.targetX
                data.curMove.targetY
                data.curMove.speed
                data.background

        newMove =
            checkDestination data.curMove newBack

        newState =
            not newMove.isMoving

        newMsg =
            if newState then
                [ Other ( "Character", EndMove ), Other ( "Trigger", PlotDone 1 ) ]

            else
                []
    in
    ( ( { data | background = newBack, curMove = newMove }, { basedata | isPlaying = not newState } )
    , newMsg
    , ( env, False )
    )
