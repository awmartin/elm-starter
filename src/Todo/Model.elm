module Todo.Model exposing (..)
import Todo.InterfaceState exposing (InterfaceState(..))

-- A single todo item.
type alias Todo =
    { id : String
    , title : String
    , state : InterfaceState
    , done : Bool
    }

-- A constructor function for todo items.
constructTodo : String -> String -> Bool -> Todo
constructTodo id title done =
    { id = id
    , title = title
    , state = Viewing
    , done = done
    }
