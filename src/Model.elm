module Model exposing (..)

import Msg exposing (Msg)
import InterfaceState exposing (InterfaceState)

import Todo.Model exposing (Todo)


-- The application state.
type alias Model =
    { todos : List Todo
    , todoTitleInputState : String
    , nextId : Int
    , lastDeletedTodo : Maybe Todo
    , messages : List Msg
    }


-- The beginning state of the application.
emptyModel : Model
emptyModel =
    { todos = []
    , todoTitleInputState = ""
    , nextId = 1
    , lastDeletedTodo = Nothing
    , messages = []
    }
