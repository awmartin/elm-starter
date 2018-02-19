module Msg exposing (..)

import Todo.Msg exposing (..)
import Model exposing (FirebaseProjectsList, FirebaseTodosList)
import Project.Model exposing (Project)
-- import Project.Firebase exposing (ProjectFirebase)

-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | UpdateInput String
    | TodoMsg TodoAction
    | SelectProject Project
    | FirebaseProjectsListUpdate FirebaseProjectsList
    | FirebaseTodosListUpdate FirebaseTodosList

