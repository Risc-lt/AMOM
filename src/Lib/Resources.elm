module Lib.Resources exposing (resources)

{-|


# Textures

@docs resources

-}

import Dict exposing (Dict)
import Messenger.Render.SpriteSheet exposing (SpriteSheet)
import Messenger.UserConfig exposing (Resources)


{-| Resources
-}
resources : Resources
resources =
    { allTexture = allTexture
    , allSpriteSheets = allSpriteSheets
    , allAudio = allAudio
    }


{-| allTexture

A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Example:

    Dict.fromList
        [ ( "ball", "assets/img/ball.png" )
        , ( "car", "assets/img/car.jpg" )
        ]

-}
allTexture : Dict String String
allTexture =
    Dict.fromList
        [ ( "monster", "assets/character/monster.png" )
        , ( "magician", "assets/character/magic.png" )
        , ( "archer", "assets/character/archer.png" )
        , ( "pharmacist", "assets/character/pharmacist.png" )
        , ( "swordsman", "assets/character/swordsman.png" )
        , ( "background ", "assets/character/background.png" )
        , ( "head_archer", "assets/character/newhead2.png" )
        , ( "head_magic", "assets/character/newhead.png" )
        , ( "dialogue_frame", "assets/character/dialogue_frame.png" )
        ]


{-| Add all your sprite sheets here.

Example:

    allSpriteSheets =
        Dict.fromList
            [ ( "spritesheet1"
              , [ ( "sp1"
                  , { realStartPoint = ( 0, 0 )
                    , realSize = ( 100, 100 )
                    }
                  )
                , ( "sp2"
                  , { realStartPoint = ( 100, 0 )
                    , realSize = ( 100, 100 )
                    }
                  )
                ]
              )
            ]

-}
allSpriteSheets : SpriteSheet
allSpriteSheets =
    Dict.fromList
        [{- ( "archer"
            , [ ( "1"
                , { realStartPoint = ( 0, 0 )
                  , realSize = ( 160, 160 )
                  }
                )
              , ( "2"
                , { realStartPoint = ( 160, 0 )
                  , realSize = ( 160, 160 )
                  }
                )
              , ( "3"
                , { realStartPoint = ( 0, 160 )
                  , realSize = ( 160, 160 )
                  }
                )
              , ( "4"
                , { realStartPoint = ( 160, 160 )
                  , realSize = ( 160, 160 )
                  }
                )
              ]
            ) as reference
         -}
        ]



--Dict.empty


{-| All audio assets.

The format is the same with `allTexture`.

-}
allAudio : Dict.Dict String String
allAudio =
    Dict.empty
