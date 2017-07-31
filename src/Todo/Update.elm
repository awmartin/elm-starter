port module Todo.Update exposing (..)

import Msg exposing (Msg)
import Model exposing (Model)
import Util exposing (..)

import Todo.Model exposing (Todo, constructTodo)
import Todo.Msg exposing (TodoAction(..))
import Todo.InterfaceState exposing (InterfaceState(..))
import Todo.Firebase exposing (TodoFirebase)


port onNewTodo : TodoFirebase -> Cmd msg
port onUpdateTodo : TodoFirebase -> Cmd msg
port onDeleteTodo : String -> Cmd msg

handleTodoAction : TodoAction -> Model -> (Model, Cmd Msg)
handleTodoAction msg model =
    case msg of
        NewTodo ->
            let newTodo =
                constructTodo "" model.todoTitleInputState
            in
                -- Just update the model's UI state. Let Firebase take care of the data.
                ({ model
                    | todoTitleInputState = ""
                },
                onNewTodo { id = "", title = newTodo.title })

        DeleteTodo id ->
            let
                deletedTodo = pluck (\todo -> todo.id == id) model.todos
            in
                ({ model
                    | lastDeletedTodo = deletedTodo
                }, onDeleteTodo id)

        UndoDelete ->
            case model.lastDeletedTodo of
                Nothing ->
                    model ! []
                Just todoToRestore ->
                    ({ model | lastDeletedTodo = Nothing }
                    , onNewTodo {id = "", title = todoToRestore.title})

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
                todo = pluck (\todo -> todo.id == id) model.todos
                view : Todo -> Todo
                view todo =
                    if todo.id == id then
                        { todo | state = Viewing }
                    else
                        todo
            in
                case todo of
                    Nothing ->
                        model ! []
                    Just todo ->
                        -- TODO Ensure the interface state is set to view, if the title hasn't
                        -- changed.
                        ( { model | todos = List.map view model.todos }
                          , onUpdateTodo (TodoFirebase id todo.title) )

        UpdateTodoTitle id newTitle ->
            let
                update : Todo -> Todo
                update todo =
                    if todo.id == id then
                        { todo | title = newTitle }
                    else
                        todo
            in
                -- Don't update Firebase.
                { model | todos = List.map update model.todos } ! []

