module Contacts.Types exposing (..)

import Json.Decode as JD


type Msg
    = NoOp
    | Paginate Int
    | SearchInput String
    | FormSubmit
    | FetchSucceed JD.Value
    | FetchError JD.Value
    | Reset
    | ShowContacts
    | ShowContact Int
