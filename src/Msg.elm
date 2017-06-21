module Msg exposing (..)

import Todo.Msg exposing (..)

-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | UpdateInput String
    | TodoMsg TodoAction

