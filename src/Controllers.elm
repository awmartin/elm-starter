module Controllers exposing (Msg(..), update)

import Models exposing (Model, Todo, constructTodo, InterfaceState(..))
import Util exposing (..)


-- The application's "messages" that initiate state changes.
type Msg =
    Noop
    | NewTodo
    | UpdateInput String
    | DeleteTodo Int
    | UndoDelete
    | EditTodo Int
    | ViewTodo Int
    | UpdateTodoTitle Int String

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
                deletedTodo = pluck (\todo -> todo.id == id) model.todos
            in
                { model
                    | todos = List.filter (\todo -> todo.id /= id) model.todos
                    , lastDeletedTodo = deletedTodo
                } ! []

        UndoDelete ->
            case model.lastDeletedTodo of
                Nothing ->
                    model ! []
                Just todoToRestore ->
                    -- Update the interface state as well so we don't undelete in the Editing state.
                    { model
                        | todos = model.todos ++ [ { todoToRestore | state = Viewing } ]
                        , lastDeletedTodo = Nothing
                    } ! []

        EditTodo id ->
            let
                edit : Todo -> Todo
                edit todo =
                    if todo.id == id then
                        { todo | state = Editing }
                    else
                        todo
            in
                { model | todos = List.map edit model.todos } ! []

        ViewTodo id ->
            let
                view : Todo -> Todo
                view todo =
                    if todo.id == id then
                        { todo | state = Viewing }
                    else
                        todo
            in
                { model | todos = List.map view model.todos } ! []

        UpdateTodoTitle id newTitle ->
            let
                update : Todo -> Todo
                update todo =
                    if todo.id == id then
                        { todo | title = newTitle }
                    else
                        todo
            in
                { model | todos = List.map update model.todos } ! []
