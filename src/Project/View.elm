module Project.View exposing (..)

import Project.Model exposing (Project)

import Msg exposing (Msg(..))
import Html exposing (..)
import Html.Keyed as Keyed
import Html.Lazy as Lazy exposing (lazy, lazy2)
import Html.Attributes as Attr exposing (..)
import Html.Events as Events

viewProjectList : List Project -> Project -> Html Msg
viewProjectList projects currentProject =
    section [] [ Keyed.ul [] <| List.map (viewKeyedProject currentProject) projects ]

viewKeyedProject : Project -> Project -> (String, Html Msg)
viewKeyedProject currentProject project =
    (toString project.id, Lazy.lazy2 viewProject currentProject project)

viewProject : Project -> Project -> Html Msg
viewProject currentProject project =
    let klass : String
        klass = if currentProject.id == project.id then "project selected" else "project"
    in
        li [ Attr.class klass ]
            [ a [Events.onClick <| SelectProject project
                , Attr.class "link"
                ] 
                [text project.title]
            ]
