module Todo.Firebase exposing (..)

import Project.Model exposing (..)

type alias TodoFirebase =
    { id : String
    , title : String
    , done : Bool
    , project : Project
    }
