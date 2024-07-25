module Scenes.Level1.Characters exposing (..)


{-
    All character data
-}


import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
import SceneProtos.Game.Components.Special.Init exposing (Skill)
import SceneProtos.Game.Components.Special.Library exposing (..)
import SceneProtos.Game.Components.GenAttributes exposing (..)


wenderd : Int -> Self
wenderd time =
    let
        baseAttributes =
            { strength = 20
            , dexterity = 20
            , constitution = 20
            , intelligence = 20
            }

        baseEleResistance =
            { waterResistance = 10
            , fireResistance = 10
            , airResistance = 10
            , earthResistance = 10
            }
    in
    genSelf 1 time "Wenderd" baseAttributes baseEleResistance
        [ arcaneBeam
        , airBlade
        ]


genSelf : Int -> Int -> String -> Attribute -> EleResistance -> List Skill -> Self
genSelf position time name baseAttributes baseEleResistance skills =
    { defaultSelf
    | name = name
    , x = if position <= 3 then 1100 else 1220
    , y = toFloat (160 + 130 * (position - (position - 1) // 3 * 3 - 1))
    , position = position
    , hp = genHp baseAttributes
    , mp = genMp baseAttributes
    , attributes = baseAttributes
    , extendValues =
        genExtendValues
            baseAttributes
            (time + 1)
            baseEleResistance.waterResistance
            baseEleResistance.fireResistance
            baseEleResistance.airResistance
            baseEleResistance.earthResistance
    , skills = skills
    }


{-| Init data for selfs
-}
selfInitData : Int -> List Self
selfInitData time =
    [ wenderd time
    ]
