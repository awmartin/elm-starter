module Views exposing (view)

import Controllers exposing (Msg(..))
import Models exposing (Model, Todo, InterfaceState(..))

import Html exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Html.Attributes exposing (..)
import Html.Keyed as Keyed
import Html.Events as Events
import Json.Decode

-- The view method consumed by the "program" method in App.elm. This effectively draws the
-- entire app.
view : Model -> Html Msg
view model =
    layout <| div []
        [ lazy viewInput model.todoTitleInputState
        , lazy viewUndoMessage model
        , lazy viewTodoList model.todos
        ]

-- HTML.text escapes all characters, so here's a non-breaking space helper.
nbsp : String
nbsp = " "

-- Wraps the given contents in the primary layout, leveraging Skeleton CSS.
layout : Html Msg -> Html Msg
layout contents =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "three columns"] [ text nbsp ]
            , div [ class "six columns"] [ contents ]
            ]
        ]

-- Draw the text input field.
viewInput : String -> Html Msg
viewInput fieldText =
    input
        [ class "new-todo u-full-width input"
        , placeholder "Enter an item here + press return."
        , autofocus True
        , value fieldText
        , name "newTodo"
        , Events.onInput UpdateInput
        , onEnter NewTodo
        ]
        []

-- Returns a method that acts as an event handler for the given keyCode.
onKeyDown : Int -> Msg -> Attribute Msg
onKeyDown targetKey msg =
    let
        isKey code =
            if code == targetKey then
                Json.Decode.succeed msg
            else
                Json.Decode.fail <| "not " ++ toString code
    in
        Events.on "keydown" <| Json.Decode.andThen isKey Events.keyCode

-- Creates a custom event listener for the return key.
onEnter : Msg -> Attribute Msg
onEnter msg =
    onKeyDown 13 msg

-- Actually draws the list of items.
viewTodoList : List Todo -> Html Msg
viewTodoList todoList =
    section [] [ Keyed.ul [] <| List.map viewKeyedTodo todoList ]

-- Provides a "keyed" representation of the list item. This helps Elm implement faster changes
-- to list-like items.
viewKeyedTodo : Todo -> (String, Html Msg)
viewKeyedTodo todo =
    (toString todo.id, lazy viewTodo todo)

-- This actually draws the <li> tag.
viewTodo : Todo -> Html Msg
viewTodo todo =
    li [ class "todo" ]
        [ viewTodoTitle todo
        , text nbsp
        , deleteLink todo
        ]

-- View method that response to the todo's interface state, either the title itself or an <input>.
viewTodoTitle : Todo -> Html Msg
viewTodoTitle todo =
    case todo.state of
        Viewing ->
            span
                [ Events.onClick <| EditTodo todo.id
                , class "todo-title"
                ]
                [ text todo.title ]
        Editing ->
            viewTodoTitleInput todo

-- Display an <input> tag for the todo's title.
viewTodoTitleInput : Todo -> Html Msg
viewTodoTitleInput todo =
    let
        handler : String -> Msg
        handler newTitle =
            UpdateTodoTitle todo.id newTitle
    in
        input [ class "todo-title-input"
            , placeholder "Todo title"
            , autofocus True
            , value todo.title
            , name "todoTitleInput"
            , Events.onInput handler
            , onEnter <| ViewTodo todo.id
            ] []

-- Display the link that will delete a todo.
deleteLink : Todo -> Html Msg
deleteLink todo =
    a
        [ Events.onClick <| DeleteTodo todo.id
        , class "link"
        ]
        [ text "×" ]

-- Display a message enabling the user to undo a delete.
viewUndoMessage : Model -> Html Msg
viewUndoMessage model =
    case model.lastDeletedTodo of
        Nothing ->
            div [] []

        Just todo ->
            div [ class "undo-message" ]
                [ text "Todo deleted."
                , text nbsp
                , a
                    [ class "link"
                    , Events.onClick UndoDelete
                    ]
                    [ text "Undo?" ]
                ]
