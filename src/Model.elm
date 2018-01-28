module Model exposing (..)

import Todo.Model exposing (Todo)
import Todo.Firebase exposing (TodoFirebase)
import Project.Model exposing (Project, constructProject)
import Project.Firebase exposing (ProjectFirebase)

-- The application state.
type alias Model =
    { todos : List Todo
    , projects: List Project
    , todoTitleInputState : String
    , nextId : Int
    , lastDeletedTodo : Maybe Todo
    , currentProject : Project
    }

-- Represents incoming data from Firebase.
type alias FirebaseData =
    { todos    : Maybe (List TodoFirebase)
    , projects : Maybe (List ProjectFirebase)
    }

-- The beginning state of the application.
emptyModel : Model
emptyModel =
    { todos = []
    , projects = []
    , todoTitleInputState = ""
    , nextId = 1
    , lastDeletedTodo = Nothing
    , currentProject = constructProject "" "Untitled"
    }
