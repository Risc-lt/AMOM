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

-}
allTexture : Dict String String
allTexture =
    Dict.fromList
        ([ ( "background", "assets/character/background/battle_background.jpg" )
         , ( "battleframe", "assets/character/chartlet/battleframe.png" )
         , ( "dialogue_frame", "assets/character/chartlet/dialogue_frame.jpg" )
         , ( "battle_background", "assets/character/background/battle_background.jpg" )
         , ( "dialogue_1", "assets/character/background/dialogue_1.jpg" )
         , ( "dialogue_3", "assets/character/background/dialogue_3.jpg" )
         , ( "dialogue_4", "assets/character/background/dialogue_4.jpg" )
         , ( "begin", "assets/character/background/Start.jpg" )
         , ( "levelselect", "assets/character/background/levelselect.jpg" )
         , ( "arrow", "assets/character/chartlet/arrow.png" )
         ]
            ++ chacaterTexture
            ++ chacaterSheetTexture
            ++ bufferTexture
        )


chacaterTexture : List ( String, String )
chacaterTexture =
    [ ( "head_bithif", "assets/character/role/role_1.jpg" )
    , ( "head_bruce", "assets/character/role/role_4.jpg" )
    , ( "head_bulingze", "assets/character/role/role_2.jpg" )
    , ( "head_wenderd", "assets/character/role/role_3.jpg" )
    , ( "head_cavalry", "assets/character/role/role_5.jpg" )
    , ( "head_magicorg", "assets/character/role/head_magicorg.jpg" )
    , ( "head_concert", "assets/character/role/head_concert.jpg" )
    ]


chacaterSheetTexture : List ( String, String )
chacaterSheetTexture =
    [ ( "BulingzeSheet", "assets/character/sprite_sheet/BulingzeSheet.jpg" )
    , ( "BruceSheet", "assets/character/sprite_sheet/BruceSheet.jpg" )
    , ( "BithifSheet", "assets/character/sprite_sheet/BithifSheet.jpg" )
    , ( "WenderdSheet", "assets/character/sprite_sheet/WenderdSheet.jpg" )
    , ( "Wild WolfSheet", "assets/character/sprite_sheet/Wild WolfSheet.jpg" )
    , ( "SwordsmanSheet", "assets/character/sprite_sheet/SwordsmanSheet.png" )
    , ( "MagicianSheet", "assets/character/sprite_sheet/MagicianSheet.png" )
    , ( "TherapistSheet", "assets/character/sprite_sheet/TherapistSheet.png" )
    , ( "CavalrySheet", "assets/character/sprite_sheet/CavalrySheet.png" )
    , ( "ConcertSheet", "assets/character/sprite_sheet/ConcertSheet.png" )
    ]


bufferTexture : List ( String, String )
bufferTexture =
    [ ( "Brave", "assets/character/buff/Brave.png" )
    , ( "Solid", "assets/character/buff/Solid.png" )
    , ( "Acceleration", "assets/character/buff/Acceleration.png" )
    , ( "Retard", "assets/character/buff/Retard.png" )
    , ( "Concentration", "assets/character/buff/Concentration.png" )
    , ( "Precision", "assets/character/buff/Precision.png" )
    , ( "Bloodthirsty", "assets/character/buff/Bloodthirsty.png" )
    , ( "Seal", "assets/character/buff/Seal.png" )
    , ( "Bleed", "assets/character/buff/Bleed.png" )
    ]


{-| Add all your sprite sheets here.
-}
allSpriteSheets : SpriteSheet
allSpriteSheets =
    Dict.fromList
        [ ( "BulingzeSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "BulingzeSheet")
          )
        , ( "BruceSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "BruceSheet")
          )
        , ( "BithifSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "BithifSheet")
          )
        , ( "WenderdSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "WenderdSheet")
          )
        , ( "CavalrySheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "CavalrySheet")
          )
        , ( "Wild WolfSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 80 * toFloat col, 80 * toFloat row )
                                  , realSize = ( 74, 74 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "Wild WolfSheet")
          )
        , ( "ConcertSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 70 * toFloat col, 70 * toFloat row )
                                  , realSize = ( 70, 70 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "ConcertSheet")
          )
        , ( "SwordsmanSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "SwordsmanSheet")
          )
        , ( "MagicianSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "MagicianSheet")
          )
        , ( "TherapistSheet"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 64 * toFloat col, 64 * toFloat row )
                                  , realSize = ( 64, 64 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    (playerSize "TherapistSheet")
          )
        ]


playerSize : String -> List Int
playerSize name =
    case name of
        "BruceSheet" ->
            [ 4, 5 ]

        "Wild WolfSheet" ->
            [ 2, 3 ]

        _ ->
            [ 4, 4 ]


{-| All audio assets.

The format is the same with `allTexture`.

-}
allAudio : Dict.Dict String String
allAudio =
    Dict.fromList
        [ ( "battle", "assets/audio/battle.ogg" )
        , ( "eased", "assets/audio/eased.ogg" )
        , ( "sad", "assets/audio/sad.ogg" )
        ]
