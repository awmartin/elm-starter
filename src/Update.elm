port module Update exposing (update)

import Array

import Model exposing (Model, FirebaseData)
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

        FirebaseUpdate data ->
            -- Converts all the Firebase objects into Todo instances.
            let convertTodo : TodoFirebase -> Todo
                convertTodo fodo =
                    constructTodo fodo.id fodo.title fodo.done fodo.project
                todoList =
                    case data.todos of
                        Nothing -> model.todos
                        Just list -> List.map convertTodo list

                convertProject : ProjectFirebase -> Project
                convertProject froject =
                    constructProject froject.id froject.title
                projectList =
                    case data.projects of
                        Nothing -> model.projects
                        Just list -> List.map convertProject list
                
                -- Handle the bootstrapping case, select the first known project.
                firstProject : Maybe Project
                firstProject = List.head projectList

                (proj, next) = if model.currentProject.id == "" then
                    case firstProject of
                        Nothing -> (model.currentProject, Cmd.none)
                        Just project -> (project, onProjectSelect project)
                    else
                        (model.currentProject, Cmd.none)
            in
                ({ model | todos = todoList, projects = projectList, currentProject = proj }, next)

        SelectProject project ->
            ({ model | currentProject = project }, onProjectSelect project)
