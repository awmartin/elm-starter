module Models exposing (..)

-- The application state.
type alias Model =
    { todos : List Todo
    , todoTitleInputState : String
    , nextId : Int
    , lastDeletedTodo : Maybe Todo
    }

-- A single todo item.
type alias Todo =
    { id : Int
    , title : String
    , state : InterfaceState
    }

type InterfaceState =
    Viewing
    | Editing

-- The beginning state of the application.
emptyModel : Model
emptyModel =
    { todos = []
    , todoTitleInputState = ""
    , nextId = 1
    , lastDeletedTodo = Nothing
    }

-- A constructor function for todo items.
constructTodo : Int -> String -> Todo
constructTodo id title =
    { id = id
    , title = title
    , state = Viewing
    }
