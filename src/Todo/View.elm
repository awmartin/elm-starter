module Todo.View exposing (..)

import Todo.Model exposing (Todo)
import Todo.Msg exposing (TodoAction(..))
import Todo.InterfaceState exposing (InterfaceState(..))

import Msg exposing (Msg(..))
import Util

import Html exposing (..)
import Html.Lazy as Lazy exposing (lazy, lazy2)
import Html.Attributes as Attr exposing (..)
import Html.Keyed as Keyed
import Html.Events as Events
import Json.Decode


-- Actually draws the list of items.
viewTodoList : List Todo -> Html Msg
viewTodoList todoList =
    section [] [ Keyed.ul [] <| List.map viewKeyedTodo todoList ]

-- Provides a "keyed" representation of the list item. This helps Elm implement faster changes
-- to list-like items.
viewKeyedTodo : Todo -> (String, Html Msg)
viewKeyedTodo todo =
    (toString todo.id, Lazy.lazy viewTodo todo)

-- This draws the <li> tag for the todo item.
viewTodo : Todo -> Html Msg
viewTodo todo =
    li [ Attr.class "todo" ]
        [ checkmark todo
        , text Util.nbsp
        , viewTodoTitle todo
        , text Util.nbsp
        , deleteLink todo
        ]

-- View method that response to the todo's interface state, either the title itself or an <input>.
viewTodoTitle : Todo -> Html Msg
viewTodoTitle todo =
    case todo.state of
        Viewing ->
            let
                todoClass =
                    if todo.done then
                        "todo-title todo-done"
                    else
                        "todo-title"
            in
                span
                    [ Events.onClick <| TodoMsg (EditTodo todo.id)
                    , Attr.class todoClass
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
            TodoMsg (UpdateTodoTitle todo.id newTitle)
    in
        input [ Attr.class "todo-title-input"
            , Attr.placeholder "Todo title"
            , Attr.autofocus True
            , Attr.value todo.title
            , Attr.name "todoTitleInput"
            , Events.onInput handler
            , onEnter <| TodoMsg (ViewTodo todo.id)
            ] []

-- Display a checkmark or box to enable users to mark todos as done/undone.
checkmark : Todo -> Html Msg
checkmark todo =
    a
        [ Events.onClick <| TodoMsg (ToggleDone todo.id)
        , Attr.class "link"
        ]
        [ text "✔" ]

-- Display the link that will delete a todo.
deleteLink : Todo -> Html Msg
deleteLink todo =
    a
        [ Events.onClick <| TodoMsg (DeleteTodo todo.id)
        , Attr.class "link"
        ]
        [ text "×" ]

-- Creates a custom event listener for the return key.
onEnter : Msg -> Attribute Msg
onEnter msg =
    onKeyDown 13 msg

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
