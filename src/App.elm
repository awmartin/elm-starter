port module App exposing (..)

import Views
import Msg exposing (Msg)
import Model exposing (Model, emptyModel)
import Update exposing (update)

import Todo.Firebase exposing (TodoFirebase)

import Html exposing (..)

-- Somehow Elm knows this is the entry point for the application.
-- http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html
main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = Views.view
        , update = update
        , subscriptions = subscriptions
        }

-- Describe the initial state and startup operations to the runtime.
init : ( Model, Cmd Msg )
init =
    Model.emptyModel ! []

port todos : (List TodoFirebase -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    -- Can do some if-statement magic here if necessary.
    todos Msg.FirebaseUpdate

