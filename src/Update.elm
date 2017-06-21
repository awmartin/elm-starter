module Update exposing (update)

import Model exposing (Model)
import Msg exposing (..)

import Todo.Update exposing (handleTodoAction)

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
