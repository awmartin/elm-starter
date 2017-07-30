module Msg exposing (..)

import Todo.Msg exposing (..)
import Todo.Firebase exposing (TodoFirebase)


-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | UpdateInput String
    | TodoMsg TodoAction
    | FirebaseUpdate (List TodoFirebase)

