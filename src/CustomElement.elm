port module CustomElement exposing (init, update, view, subscriptions)

import Html exposing (Html, div, text, h3)


--import Html.Attributes exposing (class, classList)
--import Html.Events exposing (onClick)

import Json.Decode exposing (Value, decodeValue)
import Json.Value as JsonValue exposing (decoder)
import Json.Viewer


type alias Model =
    { jsonViewer : Json.Viewer.Model
    }


init : Value -> ( Model, Cmd Msg )
init v =
    { jsonViewer = v |> JsonValue.decodeValue |> Json.Viewer.init
    }
        ! [ loadSnippet "traveller" ]


type Msg
    = JsonViewerMsg Json.Viewer.Msg
    | ChangeValue Value


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ChangeValue v ->
            { jsonViewer = v |> JsonValue.decodeValue |> Json.Viewer.init
            }
                ! []

        JsonViewerMsg m ->
            { model
                | jsonViewer =
                    model.jsonViewer
                        |> Json.Viewer.update m
            }
                ! []


view : Model -> Html Msg
view model =
    model.jsonViewer
        |> Json.Viewer.view
        |> Html.map JsonViewerMsg


port loadSnippet : String -> Cmd msg


port valueChange : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    valueChange ChangeValue
