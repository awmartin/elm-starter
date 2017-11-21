port module Todo.Update exposing (..)

import Msg exposing (Msg)
import Model exposing (Model)
import Util exposing (..)

import Todo.Model exposing (Todo, constructTodo)
import Todo.Msg exposing (TodoAction(..))
import Todo.InterfaceState exposing (InterfaceState(..))
import Todo.Firebase exposing (TodoFirebase)

-- Create ports that push events to an external receiver.
port onNewTodo : TodoFirebase -> Cmd msg
port onUpdateTodo : TodoFirebase -> Cmd msg
port onDeleteTodo : String -> Cmd msg

handleTodoAction : TodoAction -> Model -> (Model, Cmd Msg)
handleTodoAction msg model =
    case msg of
        NewTodo ->
            let newTodo =
                constructTodo "" model.todoTitleInputState False
            in
                -- Just update the model's UI state. Let Firebase take care of the data.
                ({ model
                    | todoTitleInputState = ""
                },
                onNewTodo { id = "", title = newTodo.title, done = newTodo.done })

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
                    , onNewTodo {id = "", title = todoToRestore.title, done = todoToRestore.done})

        -- Switches the UI to editing mode.
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
                        -- TODO Ensure the interface state is set to view, if the title hasn't changed.
                        -- This is where we update Firebase, once the user has decided
                        -- what the actual title value should be.
                        ( { model | todos = List.map view model.todos }
                        , onUpdateTodo (TodoFirebase id todo.title todo.done) )

        UpdateTodoTitle id newTitle ->
            let
                update : Todo -> Todo
                update todo =
                    if todo.id == id then
                        { todo | title = newTitle }
                    else
                        todo
            in
                -- Don't update Firebase, because we're just typing.
                { model | todos = List.map update model.todos } ! []

        ToggleDone id ->
            let
                update : Todo -> Todo
                update todo =
                    if todo.id == id then
                        { todo | done = not todo.done }
                    else
                        todo
                newTodos = List.map update model.todos
                todo = pluck (\todo -> todo.id == id) newTodos
            in
                  case todo of
                      Nothing ->
                          model ! []
                      Just todo ->
                          ( { model | todos = List.map update model.todos }
                          , onUpdateTodo (TodoFirebase id todo.title todo.done) )
