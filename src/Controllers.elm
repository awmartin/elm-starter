module Controllers exposing (Msg(..), update)

import Models exposing (Model, Todo, constructTodo)

import Array

-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | NewTodo
    | UpdateInput String
    | DeleteTodo Int
    | UndoDelete

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

        DeleteTodo id ->
            let
                shouldInclude : Todo -> Bool
                shouldInclude todo =
                    todo.id /= id

                deletedTodoList : List Todo
                deletedTodoList =
                    List.filter (\t -> t.id == id) model.todos

                deletedTodo : Maybe Todo
                deletedTodo =
                    if List.length deletedTodoList == 1 then
                        Array.get 0 <| Array.fromList deletedTodoList
                    else
                        Nothing
            in
                { model
                    | todos = List.filter shouldInclude model.todos
                    , lastDeletedTodo = deletedTodo
                } ! []

        UndoDelete ->
            case model.lastDeletedTodo of
                Nothing ->
                    model ! []
                Just todoToRestore ->
                    { model
                        | todos = model.todos ++ [ todoToRestore ]
                        , lastDeletedTodo = Nothing
                    } ! []
