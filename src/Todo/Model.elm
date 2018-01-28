module Todo.Model exposing (..)
import Todo.InterfaceState exposing (InterfaceState(..))
import Project.Model exposing (..)

-- A single todo item.
type alias Todo =
    { id : String
    , title : String
    , state : InterfaceState
    , done : Bool
    , project : Project
    }

-- A constructor function for todo items.
constructTodo : String -> String -> Bool -> Project -> Todo
constructTodo id title done project =
    { id = id
    , title = title
    , state = Viewing
    , done = done
    , project = project
    }
