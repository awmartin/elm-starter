module Project.Model exposing (..)

-- A single todo item.
type alias Project =
    { id : String
    , title : String
    }

constructProject : String -> String -> Project
constructProject id title =
    { id = id
    , title = title
    }
