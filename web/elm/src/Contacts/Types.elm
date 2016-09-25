module Contacts.Types exposing (..)

import Contacts.Model exposing (..)
import Http


type Msg
    = NoOp
    | Paginate Int
    | SearchInput String
    | FormSubmit
    | FetchSucceed Model
    | FetchError Http.Error
    | Reset
    | ShowContacts
    | ShowContact Int
