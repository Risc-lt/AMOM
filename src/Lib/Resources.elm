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
        [ ( "background", "assets/character/background/battle_background.jpg" )
        , ( "Fight_frame", "assets/character/chartlet/battleframe_1.png" )
        , ( "Wild Wolf", "assets/character/role/wolf.png" )
        , ( "Bulingze", "assets/character/role/magic.png" )
        , ( "Bruce", "assets/character/role/archer.png" )
        , ( "Bithif", "assets/character/role/pharmacist.png" )
        , ( "Wenderd", "assets/character/role/swordsman.png" )
        , ( "dialogue_frame", "assets/character/chartlet/dialogue_frame.jpg" )
        , ( "symbol_archer", "assets/character/chartlet/symbol_archer.png" )
        , ( "symbol_magic", "assets/character/chartlet/symbol_magic.png" )
        , ( "symbol_pharmacist", "assets/character/chartlet/symbol_fan.png" )
        , ( "symbol_swordsman", "assets/character/chartlet/symbol_sword.png" )
        , ( "battle_background", "assets/character/background/battle_background.jpg" )
        , ( "fire_ball", "assets/character/sprite_sheet/fireball_sprite.png" )
        , ( "head_bithif", "assets/character/role/role_1.jpg" )
        , ( "head_bruce", "assets/character/role/role_4.jpg" )
        , ( "head_bulingze", "assets/character/role/role_2.jpg" )
        , ( "head_wenderd", "assets/character/role/role_3.jpg" )
        , ( "role_5", "assets/character/role/role_5.jpg")
        , ( "dialogue_1", "assets/character/background/dialogue_1.jpg" )
        , ( "dialogue_2", "assets/character/background/dialogue_2.jpg" )
        , ( "dialogue_3", "assets/character/background/dialogue_3_1.jpg" )
        , ( "dialogue_4", "assets/character/background/dialogue_4.jpg" )
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
        [ ( "fire_ball"
          , [ ( "1"
              , { realStartPoint = ( 0, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "2"
              , { realStartPoint = ( 64, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "3"
              , { realStartPoint = ( 128, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "4"
              , { realStartPoint = ( 192, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "5"
              , { realStartPoint = ( 256, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "6"
              , { realStartPoint = ( 320, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "7"
              , { realStartPoint = ( 384, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "8"
              , { realStartPoint = ( 448, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "9"
              , { realStartPoint = ( 512, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "10"
              , { realStartPoint = ( 576, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "11"
              , { realStartPoint = ( 640, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "12"
              , { realStartPoint = ( 704, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "13"
              , { realStartPoint = ( 768, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "14"
              , { realStartPoint = ( 832, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "15"
              , { realStartPoint = ( 896, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "16"
              , { realStartPoint = ( 960, 0 )
                , realSize = ( 64, 64 )
                }
              )
            , ( "17"
              , { realStartPoint = ( 1024, 0 )
                , realSize = ( 64, 64 )
                }
              )
            ]
          )
        ]



--Dict.empty


{-| All audio assets.

The format is the same with `allTexture`.

-}
allAudio : Dict.Dict String String
allAudio =
    Dict.fromList
        [ ( "battle", "assets/audio/demo.ogg" )
        ]
