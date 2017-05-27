module Views exposing (view)

import Controllers exposing (Msg(..))
import Models exposing (Model, Todo)

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
    input [ class "new-todo u-full-width input"
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
    section []
        [ Keyed.ul [] <| List.map viewKeyedTodo todoList
        ]

-- Provides a "keyed" representation of the list item. This helps Elm implement faster changes
-- to list-like items.
viewKeyedTodo : Todo -> (String, Html Msg)
viewKeyedTodo todo =
    (toString todo.id, lazy viewTodo todo)

-- This actually draws the <li> tag.
viewTodo : Todo -> Html Msg
viewTodo todo =
    li []
        [ text todo.title
        , text nbsp
        , deleteLink todo
        ]

deleteLink todo =
    a
        [ Events.onClick <| DeleteTodo todo.id
        , class "link"
        ]
        [ text "x" ]
