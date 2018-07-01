port module Demo exposing (init, update, view, subscriptions)

import Html exposing (Html, div, text, h3)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Json.Decode exposing (Value, decodeValue)
import Json.Value as JsonValue exposing (decoder)
import Json.Viewer
import Snippets exposing (Snippet(..), getSnippetTitle)


type alias Model =
    { jsonViewer : Json.Viewer.Model
    , showcase : Snippet
    }


init : ( Model, Cmd Msg )
init =
    { jsonViewer = Json.Viewer.init JsonValue.NullValue
    , showcase = Traveller
    }
        ! [ loadSnippet "traveller" ]


type Msg
    = JsonViewerMsg Json.Viewer.Msg
    | SetShowcase Snippet
    | LoadSnippet Value


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        JsonViewerMsg m ->
            { model
                | jsonViewer =
                    model.jsonViewer
                        |> Json.Viewer.update m
            }
                ! []

        SetShowcase s ->
            { model
                | showcase = s
            }
                ! [ loadSnippet (toString s |> String.toLower) ]

        LoadSnippet v ->
            { model
                | jsonViewer =
                    v
                        |> JsonValue.decodeValue
                        |> Json.Viewer.init
            }
                ! []


view : Model -> Html Msg
view model =
    div []
        [ topbar model
        , content model
        ]


topbar : Model -> Html Msg
topbar model =
    [ Traveller
    , Countries
    , Addresses
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
        [ h3 [] [ text <| "Showcase: " ++ (getSnippetTitle model.showcase) ]
        , model.jsonViewer
            |> Json.Viewer.view
            |> Html.map JsonViewerMsg
        ]


port loadSnippet : String -> Cmd msg


port snippet : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    snippet LoadSnippet
