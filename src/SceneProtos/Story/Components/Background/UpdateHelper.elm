module SceneProtos.Story.Components.Background.UpdateHelper exposing (..)


import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentUpdate)
import Messenger.GeneralModel exposing (Msg(..))
import SceneProtos.Story.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Story.SceneBase exposing (SceneCommonData)
import SceneProtos.Story.Components.Background.Init exposing (InitData, Background, Camera)
import SceneProtos.Story.Components.Background.Init exposing (defaultCamera)
import SceneProtos.Story.Components.Background.Init exposing (MoveKind(..))
import SceneProtos.Story.Components.CharSequence.UpdateHelper exposing (checkDestination)
import SceneProtos.Story.Components.CharSequence.Init exposing (Character)
import SceneProtos.Story.Components.CharSequence.Init exposing (defaultCharacter)
import Messenger.Component.Component exposing (ComponentUpdateRec)


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


followMove : List Character -> ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
followMove characters env evnt data basedata =
    let
        target =
            case data.curMove.movekind of
                Follow name ->
                    Maybe.withDefault defaultCharacter <|
                        List.head <|
                            List.filter (\c -> c.name == name) characters

                _ ->
                    defaultCharacter

        curBack =
            data.background

        newBack =
            if target.name /= "" then
                { curBack | x = target.x + 50, y = target.y + 50 }

            else
                curBack
    in
    ( ( { data | background = newBack }, basedata ), [], env )

checkDestination : Camera -> Float -> Float -> Background -> Camera
checkDestination camera targetX targetY background =
    if background.x == targetX && background.y == targetY then
        { camera | isMoving = False }

    else
        camera


updateHelper : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updateHelper env _ data basedata =
    let
        newBack =
            case data.curMove.movekind of
                BySelf ( targetX, targetY ) speed ->
                    bySelfMove targetX targetY speed data.background

                _ ->
                    data.background

        newMove =
            case data.curMove.movekind of
                BySelf ( targetX, targetY ) _ ->
                    checkDestination data.curMove targetX targetY newBack

                _ ->
                    data.curMove

        newState =
            newMove.isMoving
    in
    ( ( { data | background = newBack, curMove = newMove }, { basedata | isPlaying = not newState } )
    , []
    , ( env, False ) )
