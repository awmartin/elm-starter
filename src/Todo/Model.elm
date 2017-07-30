module Todo.Model exposing (..)
import Todo.InterfaceState exposing (InterfaceState(..))

-- A single todo item.
type alias Todo =
    { id : String
    , title : String
    , state : InterfaceState
    }

-- A constructor function for todo items.
constructTodo : String -> String -> Todo
constructTodo id title =
    { id = id
    , title = title
    , state = Viewing
    }
