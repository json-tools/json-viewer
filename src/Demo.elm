module Demo exposing (init, update, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import JsonViewer
import Snippets exposing (Snippet(..), getSnippet, getSnippetTitle)


type alias Model =
    { expandedNodes : JsonViewer.ExpandedNodes
    , showcase : Snippet
    }


init : ( Model, Cmd Msg )
init =
    { expandedNodes = [ [] ]
    , showcase = Traveller
    }
        ! []


type Msg
    = ToggleNode JsonViewer.Path
    | SetShowcase Snippet


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToggleNode path ->
            { model
                | expandedNodes = model.expandedNodes |> JsonViewer.toggle path
            }
                ! []

        SetShowcase s ->
            { model | showcase = s } ! []


view : Model -> Html Msg
view model =
    div []
        [ topbar model
        , content model
        ]


topbar : Model -> Html Msg
topbar model =
    [ Traveller
    ]
        |> List.map (snippetTab model.showcase)
        |> div [ class "app-topbar" ]


snippetTab : Snippet -> Snippet -> Html Msg
snippetTab activeSnippet snippet =
    div
        [ classList
            [ ( "tab", True )
            , ( "tab--active", snippet == activeSnippet )
            ]
        , onClick <| SetShowcase snippet
        ]
        [ snippet
            |> getSnippetTitle
            |> text
        ]


content : Model -> Html Msg
content model =
    div [ class "app-content" ]
        [ model.showcase
            |> getSnippet
            |> JsonViewer.view { expandedNodes = model.expandedNodes, onToggle = ToggleNode } []
        ]
