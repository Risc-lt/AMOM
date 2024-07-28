module Lib.Resources exposing (resources)

{-|


# Textures

@docs resources

-}

import Debug exposing (toString)
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
        ([ ( "background", "assets/character/background/battle_background.jpg" )
         , ( "battleframe", "assets/character/chartlet/battleframe.png" )
         , ( "dialogue_frame", "assets/character/chartlet/dialogue_frame.png" )
         , ( "battle_background", "assets/character/background/battle_background.jpg" )
         , ( "fire_ball", "assets/character/sprite_sheet/fireball_sprite.png" )
         , ( "dialogue_1", "assets/character/background/dialogue_1.jpg" )
         , ( "dialogue_2", "assets/character/background/dialogue_2.jpg" )
         , ( "dialogue_3", "assets/character/background/dialogue_3.jpg" )
         , ( "instruction", "assets/character/background/instruction.jpg" )
         , ( "begin", "assets/character/background/Start.jpg" )
         , ( "button_1", "assets/character/chartlet/button_1.png" )
         , ( "button_2", "assets/character/chartlet/button_2.png" )
         ]
            ++ chacaterTexture
            ++ bufferTexture
        )


chacaterTexture : List ( String, String )
chacaterTexture =
    [ ( "Wild Wolf", "assets/character/role/wolf.png" )
    , ( "Bulingze", "assets/character/role/magic.png" )
    , ( "Bruce", "assets/character/role/archer.png" )
    , ( "Bithif", "assets/character/role/pharmacist.png" )
    , ( "Wenderd", "assets/character/role/swordsman.png" )
    , ( "head_bithif", "assets/character/role/role_1.jpg" )
    , ( "head_bruce", "assets/character/role/role_4.jpg" )
    , ( "head_bulingze", "assets/character/role/role_2.jpg" )
    , ( "head_wenderd", "assets/character/role/role_3.jpg" )
    ]


bufferTexture : List ( String, String )
bufferTexture =
    [ ( "Brave", "assets/character/buff/Brave.jpg" )
    , ( "Solid", "assets/character/buff/Solid.jpg" )
    , ( "Acceleration", "assets/character/buff/Acceleration.jpg" )
    , ( "Retard", "assets/character/buff/Retard.jpg" )
    , ( "Concentration", "assets/character/buff/Concentration.jpg" )
    , ( "Precision", "assets/character/buff/Precision.jpg" )
    , ( "Bloodthirsty", "assets/character/buff/Bloodthirsty.jpg" )
    , ( "Seal", "assets/character/buff/Seal.jpg" )
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
          , List.map
                (\x ->
                    let
                        basic =
                          { realStartPoint = ( 0, 0 )
                          , realSize = ( 64, 64 )
                          }
                            
                    in
                    ( toString x
                    , { basic | realStartPoint = ( 64 * x, 0 ) }
                    )
                )
                (List.map toFloat (List.range 0 17))
          )
        , ( "Bulingze" 
          , List.map
                (\x ->
                    let
                        basic =
                          { realStartPoint = ( 0, 0 )
                          , realSize = ( 64, 64 )
                          }
                            
                    in
                    ( toString x
                    , { basic | realStartPoint = ( 64 * x, 0 ) }
                    )
                )
                (List.map toFloat (List.range 0 8))
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
