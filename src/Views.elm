module Views exposing (view)

import Msg exposing (Msg(..))
import Todo.Msg exposing (TodoAction(..))
import Model exposing (Model)
import Todo.View exposing (..)
import Project.View exposing (..)

import Util exposing (..)

import Html exposing (..)
import Html.Lazy as Lazy exposing (lazy, lazy2)
import Html.Attributes as Attr exposing (..)
import Html.Events as Events


-- The view method consumed by the "program" method in App.elm. This effectively draws the
-- entire app.
view : Model -> Html Msg
view model =
    div [ Attr.class "container" ]
        [ div [ Attr.class "row" ]
            [ div [ Attr.class "two columns"] 
                [ Lazy.lazy2 viewProjectList model.projects model.currentProject ]
            , div [ Attr.class "eight columns"]
                [ Lazy.lazy viewInput model.todoTitleInputState
                , Lazy.lazy viewUndoMessage model
                , Lazy.lazy viewTodoList model.todos
                ]
            ]
        ]


-- Draw the text input field.
viewInput : String -> Html Msg
viewInput fieldText =
    input
        [ Attr.class "new-todo u-full-width input"
        , Attr.placeholder "Enter an item here + press return."
        , Attr.autofocus True
        , Attr.value fieldText
        , Attr.name "newTodo"
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
            div [ Attr.class "undo-message" ]
                [ text "Todo deleted."
                , text nbsp
                , a
                    [ Attr.class "link"
                    , Events.onClick (TodoMsg UndoDelete)
                    ]
                    [ text "Undo?" ]
                ]
