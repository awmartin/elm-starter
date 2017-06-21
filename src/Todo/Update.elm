module Todo.Update exposing (..)

import Msg exposing (Msg)
import Model exposing (Model)
import InterfaceState exposing (InterfaceState(..))
import Util exposing (..)

import Todo.Model exposing (Todo, constructTodo)
import Todo.Msg exposing (TodoAction(..))


handleTodoAction : TodoAction -> Model -> (Model, Cmd Msg)
handleTodoAction msg model =
    case msg of
        NewTodo ->
            let newTodo =
                constructTodo model.nextId model.todoTitleInputState
            in
                { model
                    | nextId = model.nextId + 1
                    , todoTitleInputState = ""
                    , todos = model.todos ++ [ newTodo ]
                } ! []


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
