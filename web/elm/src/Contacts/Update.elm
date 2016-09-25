module Contacts.Update exposing (..)

import Navigation
import Phoenix exposing (..)
import Contacts.Types exposing (..)
import Contacts.Model exposing (..)
import Routing exposing (toPath, Route(..))
import Phoenix.Push as Push
import Json.Encode as JE
import Json.Decode as JD
import Subscriptions exposing (socketUrl)
import Decoders exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Paginate pageNumber ->
            model ! [ fetchContacts model.search pageNumber ]

        FormSubmit ->
            model ! [ fetchContacts model.search 1 ]

        SearchInput search ->
            { model | search = search } ! []

        FetchSucceed raw ->
            case JD.decodeValue contactsModelDecoder raw of
                Ok newModel ->
                    newModel ! []

                Err err ->
                    let
                        _ =
                            Debug.log "error" err
                    in
                        model ! []

        FetchError error ->
            { model | error = (toString error) } ! []

        Reset ->
            { model | search = "" } ! [ fetchContacts "" 1 ]

        ShowContacts ->
            ( model, Navigation.newUrl (toPath ContactsRoute) )

        ShowContact id ->
            ( model, Navigation.newUrl (toPath (ContactRoute id)) )


fetchContacts : String -> Int -> Cmd Msg
fetchContacts search pageNumber =
    let
        payload =
            JE.object
                [ ( "search", JE.string search )
                , ( "page", JE.int pageNumber )
                ]

        push =
            Push.init "lobby" "contacts"
                |> Push.withPayload payload
                |> Push.onOk FetchSucceed
    in
        Phoenix.push socketUrl push
