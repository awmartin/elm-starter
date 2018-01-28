module Msg exposing (..)

import Todo.Msg exposing (..)
import Model exposing (FirebaseData)
import Project.Model exposing (Project)

-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | UpdateInput String
    | TodoMsg TodoAction
    | FirebaseUpdate FirebaseData
    | SelectProject Project

