module Contact.Types exposing (..)

import Json.Decode as JD


type Msg
    = FetchContact Int
    | FetchContactSucceed JD.Value
    | FetchContactError JD.Value
