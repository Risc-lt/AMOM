module Scenes.Level1.Characters exposing (..)


{-
    All character data
-}


import SceneProtos.Game.Components.Enemy.Init exposing (Enemy)
import SceneProtos.Game.Components.Self.Init exposing (Self, defaultSelf)
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
    { defaultSelf |
    name = "Wenderd"
    , x = 1100
    , y = 160
    , position = 1
    , hp = genHp baseAttributes
    , mp = genMp baseAttributes
    , energy = 0
    , attributes = baseAttributes
    , extendValues =
        genExtendValues
            baseAttributes
            (time + 1)
            baseEleResistance.waterResistance
            baseEleResistance.fireResistance
            baseEleResistance.airResistance
            baseEleResistance.earthResistance
    , buff = []
    , skills =
        [ airBlade
        , arcaneBeam
        ]
    }


genSelf : String -> Attribute -> EleResistance -> 


{-| Init data for selfs
-}
selfInitData : Int -> List Self
selfInitData time =
    [ wenderd time
    ]
    