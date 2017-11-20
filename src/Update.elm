module Update exposing (update)

import Model exposing (Model)
import Msg exposing (..)

import Todo.Model exposing (..)
import Todo.Update exposing (handleTodoAction)
import Todo.Firebase exposing (TodoFirebase)


-- The app's method to handle state changes given a particular message.
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        TodoMsg todoAction ->
            handleTodoAction todoAction model

        UpdateInput newTitle ->
            { model | todoTitleInputState = newTitle } ! []

        FirebaseUpdate list ->
            let makeTodo : TodoFirebase -> Todo
                makeTodo fodo =
                    constructTodo fodo.id fodo.title fodo.done
                todoList =
                    List.map makeTodo list
            in
                { model | todos = todoList } ! []
