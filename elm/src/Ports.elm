port module Ports exposing
    ( consoleLog
    , fullscreenChanges
    , goFullscreen
    , playAudio
    , vibrate
    , receiveUpdates
    , sendInit
    , sendUpdate
    )

{-| Provide safe interfaces to any ports
-}

import Auto.ServerUpdate exposing (ServerUpdate)
import Auto.Update exposing (Update)
import Json.Decode as JD
import Json.Encode as JE


goFullscreen : Cmd msg
goFullscreen =
    fullscreenPort ()


port fullscreenPort : () -> Cmd msg


fullscreenChanges : Sub (Result JD.Error Bool)
fullscreenChanges =
    fullscreenChangePort <|
        JD.decodeValue JD.bool


port fullscreenChangePort :
    (JD.Value -> msg)
    -> Sub msg


sendUpdate : Update -> Cmd msg
sendUpdate =
    sendUpdatePort << Auto.Update.encode


port sendUpdatePort :
    JE.Value
    -> Cmd msg


receiveUpdates : Sub (Result JD.Error (List ServerUpdate))
receiveUpdates =
    receiveUpdatePort <|
        JD.decodeValue decodeUpdates


decodeUpdates : JD.Decoder (List ServerUpdate)
decodeUpdates =
    JD.oneOf
        [ Auto.ServerUpdate.decode |> JD.map List.singleton
        , JD.list Auto.ServerUpdate.decode
        ]


port receiveUpdatePort :
    (JD.Value -> msg)
    -> Sub msg


consoleLog : String -> Cmd msg
consoleLog =
    logPort


port logPort :
    String
    -> Cmd msg


sendInit : Cmd msg
sendInit =
    initPort ()


port initPort :
    ()
    -> Cmd msg


playAudio : String -> Cmd msg
playAudio =
    audioPort


port audioPort :
    String
    -> Cmd msg


vibrate : List Int -> Cmd msg
vibrate =
    vibratePort


port vibratePort :
    List Int
    -> Cmd msg
