module Scenes.Before1.Characters exposing (charInitData)

{-|


# Before1 Characters module

This module contains the characters data for the Before1 scene.

@docs charInitData

-}

import SceneProtos.Story.Components.CharSequence.Init exposing (Direction(..), InitData, MoveKind(..), Movement, Posture(..))
import Scenes.Before1.Characters2 exposing (characters, genMove)


begin : List Movement
begin =
    let
        wenderdMove =
            Real ( 910, 350 ) 8

        bulingzeMove =
            Real ( 670, 490 ) 8

        bruceMove =
            Real ( 430, 350 ) 8

        bithifMove =
            Real ( 190, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 1
    , genMove "Bulingze" Battle bulingzeMove 1
    , genMove "Bruce" Battle bruceMove 1
    , genMove "Bithif" Battle bithifMove 1
    ]


followRight : List Movement
followRight =
    let
        movekind =
            Fake Right
    in
    [ genMove "Wenderd" Battle movekind 2
    , genMove "Bulingze" Battle movekind 2
    , genMove "Bruce" Battle movekind 2
    , genMove "Bithif" Battle movekind 2
    ]


bySelfRight : List Movement
bySelfRight =
    let
        wenderdMove =
            Real ( 1100, 490 ) 8

        bulingzeMove =
            Real ( 960, 490 ) 8

        bruceMove =
            Real ( 760, 350 ) 8

        bithifMove =
            Real ( 520, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 3
    , genMove "Bulingze" Battle bulingzeMove 3
    , genMove "Bruce" Battle bruceMove 3
    , genMove "Bithif" Battle bithifMove 3
    ]


throughStone1 : List Movement
throughStone1 =
    let
        wenderdMove =
            Real ( 1580, 490 ) 8

        bulingzeMove =
            Real ( 1420, 470 ) 8

        bruceMove =
            Real ( 1100, 490 ) 8

        bithifMove =
            Real ( 960, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 4
    , genMove "Bulingze" Battle bulingzeMove 4
    , genMove "Bruce" Battle bruceMove 4
    , genMove "Bithif" Battle bithifMove 4
    ]


throughStone2 : List Movement
throughStone2 =
    let
        wenderdMove =
            Real ( 1660, 450 ) 8

        bulingzeMove =
            Real ( 1420, 350 ) 8

        bruceMove =
            Real ( 1220, 490 ) 8

        bithifMove =
            Real ( 1080, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 5
    , genMove "Bulingze" Battle bulingzeMove 5
    , genMove "Bruce" Battle bruceMove 5
    , genMove "Bithif" Battle bithifMove 5
    ]


throughStone3 : List Movement
throughStone3 =
    let
        wenderdMove =
            Real ( 1660, 350 ) 8

        bulingzeMove =
            None Left

        bruceMove =
            Real ( 1320, 490 ) 8

        bithifMove =
            Real ( 1180, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 6
    , genMove "Bulingze" Battle bulingzeMove 6
    , genMove "Bruce" Battle bruceMove 6
    , genMove "Bithif" Battle bithifMove 6
    ]


throughStone4 : List Movement
throughStone4 =
    let
        wenderdMove =
            None Right

        bulingzeMove =
            None Left

        bruceMove =
            Real ( 1560, 490 ) 8

        bithifMove =
            Real ( 1420, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 7
    , genMove "Bulingze" Battle bulingzeMove 7
    , genMove "Bruce" Battle bruceMove 7
    , genMove "Bithif" Battle bithifMove 7
    ]


throughStone5 : List Movement
throughStone5 =
    let
        wenderdMove =
            None Right

        bulingzeMove =
            None Left

        bruceMove =
            Real ( 1660, 490 ) 8

        bithifMove =
            None Left
    in
    [ genMove "Wenderd" Battle wenderdMove 8
    , genMove "Bulingze" Battle bulingzeMove 8
    , genMove "Bruce" Battle bruceMove 8
    , genMove "Bithif" Battle bithifMove 8
    ]


turnLeft : List Movement
turnLeft =
    let
        wenderdMove =
            None Left

        bruceMove =
            None Left
    in
    [ genMove "Wenderd" Battle wenderdMove 10
    , genMove "Bruce" Battle bruceMove 10
    ]


followLeft : List Movement
followLeft =
    let
        wenderdMove =
            Follow ( 2299, 350 ) 8

        bulingzeMove =
            Follow ( 2059, 350 ) 8

        bruceMove =
            Follow ( 2299, 490 ) 8

        bithifMove =
            Follow ( 2059, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 11
    , genMove "Bulingze" Battle bulingzeMove 11
    , genMove "Bruce" Battle bruceMove 11
    , genMove "Bithif" Battle bithifMove 11
    ]


wolfAppear : List Movement
wolfAppear =
    let
        move1 =
            Real ( 910, 350 ) 8

        move2 =
            Real ( 840, 490 ) 8

        move3 =
            Real ( 760, 350 ) 8

        move4 =
            Real ( 690, 520 ) 8

        move5 =
            Real ( 550, 420 ) 8

        move6 =
            Real ( 430, 350 ) 8
    in
    [ genMove "Wild Wolf1" Battle move1 12
    , genMove "Wild Wolf2" Battle move2 12
    , genMove "Wild Wolf3" Battle move3 12
    , genMove "Wild Wolf4" Battle move4 12
    , genMove "Wild Wolf5" Battle move5 12
    , genMove "Wild Wolf6" Battle move6 12
    ]


wolfRight : List Movement
wolfRight =
    let
        wolfMove =
            Fake Right

        wenderdMove =
            Follow ( 1660, 350 ) 8

        bulingzeMove =
            Follow ( 1420, 350 ) 8

        bruceMove =
            Follow ( 1660, 490 ) 8

        bithifMove =
            Follow ( 1420, 490 ) 8
    in
    [ genMove "Wenderd" Battle wenderdMove 13
    , genMove "Bulingze" Battle bulingzeMove 13
    , genMove "Bruce" Battle bruceMove 13
    , genMove "Bithif" Battle bithifMove 13
    , genMove "Wild Wolf1" Battle wolfMove 13
    , genMove "Wild Wolf2" Battle wolfMove 13
    , genMove "Wild Wolf3" Battle wolfMove 13
    , genMove "Wild Wolf4" Battle wolfMove 13
    , genMove "Wild Wolf5" Battle wolfMove 13
    , genMove "Wild Wolf6" Battle wolfMove 13
    ]


{-| Characters: Init data
-}
charInitData : InitData
charInitData =
    { characters = characters
    , curMove = []
    , remainMove =
        begin
            ++ followRight
            ++ bySelfRight
            ++ throughStone1
            ++ throughStone2
            ++ throughStone3
            ++ throughStone4
            ++ throughStone5
            ++ turnLeft
            ++ followLeft
            ++ wolfAppear
            ++ wolfRight
    }
