port module CustomElement exposing (init, update, view, subscriptions)

import Html exposing (Html, div, text, h3)


--import Html.Attributes exposing (class, classList)
--import Html.Events exposing (onClick)

import Json.Decode exposing (Value, decodeValue, list, string, maybe, field)
import Json.Value as JsonValue exposing (decoder)
import Json.Viewer


type alias Model =
    { jsonViewer : Json.Viewer.Model
    }


init : Value -> ( Model, Cmd Msg )
init v =
    let
        attributes =
            v
                |> JsonValue.decodeValue

        inspectedValue =
            attributes
                |> JsonValue.getIn [ "value" ]
                |> Result.withDefault JsonValue.NullValue

        expandedNodes =
            v
                |> decodeValue (field "expandedNodes" (list (list string)))
                |> Result.toMaybe
    in
        { jsonViewer =
            inspectedValue
                |> Json.Viewer.init expandedNodes
        }
            ! []


type Msg
    = JsonViewerMsg Json.Viewer.Msg
    | ChangeValue Value
    | ExpandedNodesChange Value


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ChangeValue v ->
            { jsonViewer =
                v
                    |> JsonValue.decodeValue
                    |> Json.Viewer.updateValue model.jsonViewer
            }
                ! []

        ExpandedNodesChange v ->
            { jsonViewer =
                v
                    |> Json.Decode.decodeValue (list (list string))
                    |> Result.withDefault []
                    |> Debug.log "expandedNodes update"
                    |> Json.Viewer.updateExpandedNodes model.jsonViewer
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


port valueChange : (Value -> msg) -> Sub msg


port expandedNodesChange : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ valueChange ChangeValue
        , expandedNodesChange ExpandedNodesChange
        ]
