module Controllers exposing (Msg(..), update)

import Models exposing (Model, constructTodo)

-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | NewTodo
    | UpdateInput String

-- The app's method to handle state changes given a particular message.
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        NewTodo ->
            let newTodo =
                Models.constructTodo model.nextId model.todoTitleInputState
            in
                { model
                    | nextId = model.nextId + 1
                    , todoTitleInputState = ""
                    , todos = model.todos ++ [ newTodo ]
                } ! []

        UpdateInput newTitle ->
            { model | todoTitleInputState = newTitle } ! []
