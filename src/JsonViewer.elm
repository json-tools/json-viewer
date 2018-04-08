module JsonViewer exposing (JsonViewer, ExpandedNodes, Path, view, toggle)

{-|
@docs JsonViewer, ExpandedNodes, Path, view, toggle
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import JsonValue exposing (JsonValue)


{-|
Expanded nodes in JSON value, use it to define model

    type alias Model =
        { expandedNodes : JsonViewer.ExpandedNodes
        , {- ... the rest of applications model -}
        }
-}
type alias ExpandedNodes =
    List Path


{-|
Path in JSON value
-}
type alias Path =
    List String


{-|
Configuration for JsonViewer component
-}
type alias JsonViewer msg =
    { expandedNodes : ExpandedNodes
    , onToggle : Path -> msg
    }


{-|
Toggle expandable node. A helper to use in update function:

    type Msg
        = ToggleNode Path
        | {- ...the rest of your application messages... -}

    update msg model =
        case msg of
            ToggleNode path ->
                { model
                    | expandedNodes = model.expandedNodes
                        |> toggle path
                }
                    ! []

            {- ... -}

-}
toggle : Path -> ExpandedNodes -> ExpandedNodes
toggle path expandedNodes =
    if List.member path expandedNodes then
        expandedNodes |> List.filter ((/=) path)
    else
        path :: expandedNodes


{-|
Render JsonViewer

    jsonValue
        |> view
            { expandedNodes = expandedNodes
            , onToggle = ToggleNode
            } []
-}
view : JsonViewer msg -> Path -> JsonValue -> Html msg
view jvr path jv =
    case jv of
        JsonValue.BoolValue bv ->
            bv
                |> boolToString
                |> text
                |> inline JsonBoolean

        JsonValue.NumericValue nv ->
            nv
                |> toString
                |> text
                |> inline JsonNumber

        JsonValue.StringValue sv ->
            sv
                |> toString
                |> text
                |> inline JsonString

        JsonValue.NullValue ->
            "null"
                |> text
                |> inline JsonNull

        JsonValue.ObjectValue props ->
            if List.member path jvr.expandedNodes then
                props
                    |> List.map
                        (\( k, v ) ->
                            div [ class "json-viewer json-viewer__object-property" ]
                                [ span [ class "json-viewer json-viewer__key" ] [ text k ]
                                , v |> view jvr (path ++ [ k ])
                                ]
                        )
                    |> div [ class "json-viewer json-viewer--expandable" ]
            else
                props
                    |> List.take 5
                    |> List.map (\( k, _ ) -> k)
                    |> String.join ", "
                    |> (\s ->
                            span
                                [ class "json-viewer json-viewer--collapsed"
                                , onClick <| jvr.onToggle path
                                ]
                                [ "{ " ++ s ++ "... }" |> text ]
                       )

        JsonValue.ArrayValue items ->
            if List.member path jvr.expandedNodes then
                items
                    |> List.indexedMap
                        (\index v ->
                            div [ class "json-viewer json-viewer__array-item" ]
                                [ span [ class "json-viewer json-viewer__key" ] [ toString index |> text ]
                                , v |> view jvr (path ++ [ toString index ])
                                ]
                        )
                    |> div [ class "json-viewer json-viewer--expandable" ]
            else
                span
                    [ class "json-viewer json-viewer--collapsed"
                    , onClick <| jvr.onToggle path
                    ]
                    [ "[ " ++ (List.length items |> toString) ++ " items... ]" |> text
                    ]


type JsonType
    = JsonBoolean
    | JsonString
    | JsonNumber
    | JsonNull


inline : JsonType -> Html msg -> Html msg
inline jsonType el =
    span
        [ class <| "json-viewer json-viewer--" ++ (jsonTypeToString jsonType) ]
        [ el ]


jsonTypeToString : JsonType -> String
jsonTypeToString t =
    case t of
        JsonBoolean ->
            "bool"

        JsonString ->
            "string"

        JsonNumber ->
            "number"

        JsonNull ->
            "null"


boolToString : Bool -> String
boolToString bv =
    if bv then
        "true"
    else
        "false"
