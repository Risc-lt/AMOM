module Scenes.Game.Components.Self.Init exposing
    ( InitData
    , Self, State(..), defaultSelf, emptyInitData
    )

{-|


# Init module

@docs InitData

-}

import Scenes.Game.Components.GenAttributes exposing (..)
import Time exposing (ZoneName(..))


{-| Character state
-}
type State
    = Working
    | Waiting


{-| Core data structure for the self
-}
type alias Self =
    { name : String
    , x : Float
    , y : Float
    , position : Int
    , hp : Int
    , mp : Int
    , energy : Int
    , attributes : Attribute
    , extendValues : ExtendValue
    , state : State
    }


{-| The data used to initialize the scene
-}
type alias InitData =
    List Self


{-| Base attributes for the self
-}
baseAttributes : Attribute
baseAttributes =
    { strength = 20
    , dexterity = 20
    , constitution = 20
    , intelligence = 20
    }


{-| Base elemental resistance for the self
-}
baseEleResistance : EleResistance
baseEleResistance =
    { waterResistance = 10
    , fireResistance = 10
    , airResistance = 10
    , earthResistance = 10
    }


{-| Empty init data for self
-}
emptyInitData : Int -> InitData
emptyInitData time =
    [ { name = "Wenderd"
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
      , state = Waiting
      }
    , { name = "Bruce"
      , x = 1100
      , y = 290
      , position = 2
      , hp = genHp baseAttributes
      , mp = genMp baseAttributes
      , energy = 0
      , attributes = baseAttributes
      , extendValues =
            genExtendValues
                baseAttributes
                (time + 2)
                baseEleResistance.waterResistance
                baseEleResistance.fireResistance
                baseEleResistance.airResistance
                baseEleResistance.earthResistance
      , state = Waiting
      }
    , { name = ""
      , x = 1100
      , y = 420
      , position = 3
      , hp = 0
      , mp = 0
      , energy = 0
      , attributes = defaultAttributes
      , extendValues = defaultExtendValues
      , state = Waiting
      }
    , { name = "Bulingze"
      , x = 1220
      , y = 160
      , position = 4
      , hp = genHp baseAttributes
      , mp = genMp baseAttributes
      , energy = 0
      , attributes = baseAttributes
      , extendValues =
            genExtendValues
                baseAttributes
                (time + 4)
                baseEleResistance.waterResistance
                baseEleResistance.fireResistance
                baseEleResistance.airResistance
                baseEleResistance.earthResistance
      , state = Waiting
      }
    , { name = "Bithif"
      , x = 1220
      , y = 290
      , position = 5
      , hp = genHp baseAttributes
      , mp = genMp baseAttributes
      , energy = 0
      , attributes = baseAttributes
      , extendValues =
            genExtendValues
                baseAttributes
                (time + 5)
                baseEleResistance.waterResistance
                baseEleResistance.fireResistance
                baseEleResistance.airResistance
                baseEleResistance.earthResistance
      , state = Waiting
      }
    , { name = ""
      , x = 1220
      , y = 420
      , position = 6
      , hp = 0
      , mp = 0
      , energy = 0
      , attributes = defaultAttributes
      , extendValues = defaultExtendValues
      , state = Waiting
      }
    ]


{-| The default data for the self
-}
defaultSelf : Self
defaultSelf =
    { name = ""
    , x = 0
    , y = 0
    , position = 1
    , hp = 0
    , mp = 0
    , energy = 0
    , attributes = defaultAttributes
    , extendValues = defaultExtendValues
    , state = Waiting
    }
