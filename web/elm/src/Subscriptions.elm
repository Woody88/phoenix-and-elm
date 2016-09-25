module Subscriptions exposing (..)

import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)
import Model exposing (..)
import Types exposing (..)


socketUrl : String
socketUrl =
    "ws://localhost:4000/socket/websocket"


{-| Initialize a socket with the default heartbeat intervall of 30 seconds
-}
socket : Socket
socket =
    Socket.init socketUrl


lobby : Channel Types.Msg
lobby =
    Channel.init "lobby"
        |> Channel.onJoin (\_ -> UpdateState JoinedLobby)
        |> Channel.withDebug


subscriptions : Model -> Sub Types.Msg
subscriptions model =
    case model.state of
        _ ->
            Phoenix.connect socket [ lobby ]
