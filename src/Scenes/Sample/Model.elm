module Scenes.Sample.Model exposing (scene)

{-|


# Level configuration module

-}

import Json.Encode exposing (object)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env)
import Messenger.Scene.RawScene exposing (RawSceneProtoLevelInit)
import Messenger.Scene.Scene exposing (SceneStorage)
import SceneProtos.Story.Components.CharSequence.Model as Character
import SceneProtos.Story.Components.Character.Msg exposing (Name(..))
import SceneProtos.Story.Components.ComponentBase exposing (CharAction(..), CharSequenceDeliver, ComponentMsg(..))
import SceneProtos.Story.Components.DialogSequence.Model as Dialogue
import SceneProtos.Story.Init exposing (Character, Dialogue, InitData)
import SceneProtos.Story.Model exposing (genScene)


init : RawSceneProtoLevelInit UserData SceneMsg (InitData SceneMsg)
init env msg =
    Just (initData env msg)


initData : Env () UserData -> Maybe SceneMsg -> InitData SceneMsg
initData env msg =
    let
        objectBulingze =
            { standingFigure = "Bulingze"
            , movingSheet = "archer"
            }

        diaDeli =
            { speaker = "Bithif"
            , content = [ "This is first line.", "This is second line." ]
            , next = [ UpdateCharSequenceMsg updateBulingzeInOrder3 ]
            , nextTar = [ "CharSequenceBulingze" ]
            }

        updateBulingzeInOrder3 =
            { object = objectBulingze
            , id = 1
            , action = MoveDown 200
            , nextMsg = [ NullComponentMsg ]
            , nextTar = []
            }

        diaBulingze =
            { object = objectBulingze
            , id = 1
            , action = MoveLeft 100
            , nextMsg = [ NewDialogSequenceMsg diaDeli ]
            , nextTar = [ "DialogueSequence" ]
            , position = ( 500, 500 )
            }

        _ =
            Debug.log "objectBulingze" objectBulingze
    in
    { objects =
        [ Debug.log "a" Character.component (NewCharSequenceMsg <| diaBulingze)
        , Debug.log "b" Dialogue.component NullComponentMsg
        ]
    , order = "Sample"
    }


{-| Scene storage
-}
scene : SceneStorage UserData SceneMsg
scene =
    genScene init
