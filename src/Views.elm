module Views exposing (view)

import Msg exposing (Msg(..))
import Todo.Msg exposing (TodoAction(..))
import Model exposing (Model)
import Todo.View exposing (..)
import Util exposing (..)

import Html exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Html.Attributes exposing (..)
import Html.Events as Events


-- The view method consumed by the "program" method in App.elm. This effectively draws the
-- entire app.
view : Model -> Html Msg
view model =
    layout <| div []
        [ lazy viewInput model.todoTitleInputState
        , lazy viewUndoMessage model
        , lazy viewTodoList model.todos
        ]


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
        , onEnter (TodoMsg NewTodo)
        ]
        []



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
                    , Events.onClick (TodoMsg UndoDelete)
                    ]
                    [ text "Undo?" ]
                ]
