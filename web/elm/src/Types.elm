module Types exposing (..)

import Contacts.Types exposing (..)
import Contact.Types exposing (..)
import Model exposing (..)


type Msg
    = ContactsMsg Contacts.Types.Msg
    | ContactMsg Contact.Types.Msg
    | UpdateState State
