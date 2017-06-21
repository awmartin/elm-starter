module Todo.Model exposing (..)

import InterfaceState exposing (InterfaceState(..))

-- A single todo item.
type alias Todo =
    { id : Int
    , title : String
    , state : InterfaceState
    }

-- A constructor function for todo items.
constructTodo : Int -> String -> Todo
constructTodo id title =
    { id = id
    , title = title
    , state = Viewing
    }
