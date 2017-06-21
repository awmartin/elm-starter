module Model exposing (..)

import Todo.Model exposing (Todo)
import InterfaceState exposing (InterfaceState)

-- The application state.
type alias Model =
    { todos : List Todo
    , todoTitleInputState : String
    , nextId : Int
    , lastDeletedTodo : Maybe Todo
    }


-- The beginning state of the application.
emptyModel : Model
emptyModel =
    { todos = []
    , todoTitleInputState = ""
    , nextId = 1
    , lastDeletedTodo = Nothing
    }
