module Scenes.Level2.Plots exposing (..)

{-
   All plot data
-}

import SceneProtos.Game.Components.Dialogue.Init exposing (Dialogue, defaultDialogue)
import SceneProtos.Game.Components.StoryTrigger.Init exposing (TriggerConditions(..))
import SubstanceAmount exposing (gigamoles)


amaze : Dialogue
amaze =
    let
        content =
            [ "Wenderd:"
            , "Damn, this guy is so strong."
            ]
    in
    genDialogue "head_wenderd" content ( 1, 1 )


appreciate : Dialogue
appreciate =
    let
        content =
            [ "Concert:"
            , "You guys are not bad either."
            ]
    in
    genDialogue "head_concert" content ( 1, 2 )


plaint : Dialogue
plaint =
    let
        content =
            [ "Concert:"
            , "I think I've heard of you guys, 'Nightfall Knights'."
            , "I didn't expect we'd actually fight each other."
            ]
    in
    genDialogue "head_concert" content ( 1, 3 )


weak : Dialogue
weak =
    let
        content =
            [ "Wenderd:"
            , "His weakness is air. Use your magics, Bithif!"
            ]
    in
    genDialogue "head_wenderd" content ( 2, 1 )


confused1 : Dialogue
confused1 =
    let
        content =
            [ "Concert:"
            , "It's strange, you seem to have fangs in your mouth."
            , "Are you from the desert races?"
            ]
    in
    genDialogue "head_concert" content ( 2, 2 )


bad : Dialogue
bad =
    let
        content =
            [ "Wenderd:"
            , "Hmm... So bad now."
            ]
    in
    genDialogue "head_wenderd" content ( 3, 1 )


worry : Dialogue
worry =
    let
        content =
            [ "Bruce:"
            , "Wenderd! Are you all right?"
            ]
    in
    genDialogue "head_bruce" content ( 3, 2 )


confused2 : Dialogue
confused2 =
    let
        content =
            [ "Concert:"
            , "I seem to have seen a look as hungry as"
            , "yours somewhere before."
            ]
    in
    genDialogue "head_concert" content ( 3, 3 )


understand : Dialogue
understand =
    let
        content =
            [ "Concert:"
            , "Ah, I see. Well, well, well..."
            ]
    in
    genDialogue "head_concert" content ( 3, 4 )


guess : Dialogue
guess =
    let
        content =
            [ "Concert:"
            , "You are vampires, aren't you? "
            , "Those man-eating monsters, "
            , "the remnants of an evil race left on the ground."
            ]
    in
    genDialogue "head_concert" content ( 3, 5 )


surprise : Dialogue
surprise =
    let
        content =
            [ "Bruce:"
            , "!!!"
            ]
    in
    genDialogue "head_bruce" content ( 3, 6 )


silence : Dialogue
silence =
    let
        content =
            [ "Bithif:"
            , "..."
            ]
    in
    genDialogue "head_bruce" content ( 3, 7 )


provoke : Dialogue
provoke =
    let
        content =
            [ "Concert:"
            , "I guessed right, didn't I? Tell me,"
            , "how many people have you killed, huh?"
            ]
    in
    genDialogue "head_concert" content ( 3, 8 )


counter : Dialogue
counter =
    let
        content =
            [ "Bulingze:"
            , "Shut up! We're better than you!"
            ]
    in
    genDialogue "head_bulingze" content ( 3, 9 )


abuse : Dialogue
abuse =
    let
        content =
            [ "Concert:"
            , "Don't compare me to evil creatures like you."
            , "I am still a human after all, not a monster."
            ]
    in
    genDialogue "head_concert" content ( 3, 10 )


scorn : Dialogue
scorn =
    let
        content =
            [ "Concert:"
            , "Killing you is probably one of the few"
            , "good things I have done."
            ]
    in
    genDialogue "head_concert" content ( 3, 11 )


genDialogue : String -> List String -> ( Int, Int ) -> Dialogue
genDialogue speaker content id =
    { defaultDialogue
        | speaker = speaker
        , content = content
        , id = id
    }


dialogueInitData : { curDialogue : Dialogue, remainDiaList : List Dialogue }
dialogueInitData =
    { curDialogue = defaultDialogue
    , remainDiaList =
        [ amaze
        , appreciate
        , plaint
        , weak
        , confused1
        , bad
        , worry
        , confused2
        , understand
        , guess
        , surprise
        , silence
        , provoke
        , counter
        , abuse
        , scorn
        ]
    }


amazeTrigger : ( TriggerConditions, Int )
amazeTrigger =
    ( FrameTrigger 5, 1 )


weakTrigger : ( TriggerConditions, Int )
weakTrigger =
    ( FrameTrigger 10, 1 )


badTrigger : ( TriggerConditions, Int )
badTrigger =
    ( FrameTrigger 15, 1 )


triggerInitData : List ( TriggerConditions, Int )
triggerInitData =
    [ amazeTrigger
    , weakTrigger
    , badTrigger
    ]
