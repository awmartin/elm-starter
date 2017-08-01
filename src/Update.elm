module Update exposing (update)

import Model exposing (Model)
import Msg exposing (..)

import Todo.Update

-- The app's method to handle state changes given a particular message.
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newMessages = if isUndoable msg then
            model.messages ++ [ msg ]
        else
            model.messages
        
        newModel =
            case msg of
                Noop ->
                    model ! []

                TodoMsg subMsg ->
                    Todo.Update.handleTodoAction subMsg model ! []
                        
                UpdateInput newTitle ->
                    { model | todoTitleInputState = newTitle } ! []
    in
        { model | messages = newMessages } ! []

isUndoable : Msg -> Bool
isUndoable msg =
    case msg of
        Noop -> False
        TodoMsg action -> Todo.Update.isUndoable action
        UpdateInput newTitle -> False
