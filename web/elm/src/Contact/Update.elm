module Contact.Update exposing (..)

import Phoenix exposing (..)
import Contact.Types exposing (..)
import Contact.Model exposing (..)
import Phoenix.Push as Push
import Json.Decode as JD
import Subscriptions exposing (socketUrl)
import Decoders exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchContact id ->
            ( model, fetchContact id )

        FetchContactSucceed raw ->
            case JD.decodeValue contactModelDecoder raw of
                Ok newModel ->
                    newModel ! []

                Err err ->
                    let
                        _ =
                            Debug.log "error" err
                    in
                        model ! []

        FetchContactError raw ->
            case JD.decodeValue contactModelDecoder raw of
                Ok res ->
                    { model | error = Just (toString (Maybe.withDefault "" res.error)) } ! []

                Err err ->
                    let
                        _ =
                            Debug.log "error" err
                    in
                        model ! []


fetchContact : Int -> Cmd Msg
fetchContact id =
    let
        push =
            Push.init "lobby" ("contact:" ++ toString id)
                |> Push.onOk FetchContactSucceed
                |> Push.onError FetchContactError
    in
        Phoenix.push socketUrl push
