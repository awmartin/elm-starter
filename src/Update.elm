port module Update exposing (update)


import Model exposing (Model)
import Msg exposing (..)

import Todo.Model exposing (..)
import Todo.Update exposing (handleTodoAction)
import Todo.Firebase exposing (TodoFirebase)

import Project.Model exposing (..)
import Project.Firebase exposing (ProjectFirebase)

port onProjectSelect : Project -> Cmd msg


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

        SelectProject project ->
            ({ model | currentProject = project }, onProjectSelect project)

        FirebaseProjectsListUpdate frojects ->
            let convertProject : ProjectFirebase -> Project
                convertProject froject =
                    constructProject froject.id froject.title
                projectList = List.map convertProject frojects
                
                -- Handle the bootstrapping case, select the first known project.
                firstProject : Maybe Project
                firstProject = List.head projectList

                (proj, next) = if model.currentProject.id == "" then
                    case firstProject of
                        Nothing -> (model.currentProject, Cmd.none)
                        Just project -> (project, onProjectSelect project) -- Ensures the todo list is populated.
                    else
                        (model.currentProject, Cmd.none)
            in
                ({ model | projects = projectList, currentProject = proj }, next)

        FirebaseTodosListUpdate fodos ->
            let convertTodo : TodoFirebase -> Todo
                convertTodo fodo =
                    constructTodo fodo.id fodo.title fodo.done fodo.project
                todoList = List.map convertTodo fodos
            in
                ({model | todos = todoList}, Cmd.none)
