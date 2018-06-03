module Json.Viewer exposing (Model, Msg, init, update, view)

{-|
@docs Model, Msg, init, update, view
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import JsonValue exposing (JsonValue)


{-|
Local state of Json.Viewer component

    type alias Model =
        { jsonViewer : Json.Viewer.Model
        , {- ... the rest of applications model -}
        }
-}
type alias Model =
    { expandedNodes : List Path
    , jsonValue : JsonValue
    }


{-|
Local messages of Json.Viewer component
-}
type Msg
    = Toggle Path


type alias Path =
    List String


{-|
Configuration for Json.Viewer component
-}
init : JsonValue -> Model
init jsonValue =
    { expandedNodes = [], jsonValue = jsonValue }


{-|
Toggle expandable node. A helper to use in update function:

    type Msg
        = ToggleNode Path
        | {- ...the rest of your application messages... -}

    update msg model =
        case msg of
            JsonViewer m ->
                { model
                    | jsonViewer = model.jsonViewer |> update m
                }
                    ! []

            {- ... -}

-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle path ->
            if List.member path model.expandedNodes then
                { model | expandedNodes = model.expandedNodes |> List.filter ((/=) path) }
            else
                { model | expandedNodes = path :: model.expandedNodes }


{-|
Render JsonViewer

    jsonValue
        |> view
            { expandedNodes = expandedNodes
            , onToggle = ToggleNode
            } []
-}
view : Model -> Html Msg
view model =
    case model.jsonValue of
        JsonValue.ObjectValue _ ->
            viewChildProp "" model.jsonValue [] model.expandedNodes

        JsonValue.ArrayValue _ ->
            viewChildProp "" model.jsonValue [] model.expandedNodes

        _ ->
            viewComponent model.expandedNodes [] model.jsonValue


viewComponent : List Path -> Path -> JsonValue -> Html Msg
viewComponent expandedNodes path jv =
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
            if List.member path expandedNodes then
                props
                    |> List.map
                        (\( k, v ) ->
                            viewChildProp k v path expandedNodes
                        )
                    |> div [ class "json-viewer json-viewer--expandable" ]
            else
                text ""

        JsonValue.ArrayValue items ->
            if List.member path expandedNodes then
                items
                    |> List.indexedMap
                        (\index v ->
                            viewChildProp (toString index) v path expandedNodes
                        )
                    |> div [ class "json-viewer json-viewer--expandable" ]
            else
                span
                    [ class "json-viewer json-viewer--collapsed"
                    , onClick <| Toggle path
                    ]
                    [ "[ " ++ (List.length items |> toString) ++ " items... ]" |> text
                    ]


viewChildProp : String -> JsonValue -> List String -> List Path -> Html Msg
viewChildProp k v path expandedNodes =
    let
        childPath =
            path ++ [ k ]

        childExpanded =
            List.member childPath expandedNodes

        toggle =
            div
                [ class "json-viewer__toggle"
                , onClick <| Toggle childPath
                ]
                [ if childExpanded then
                    text "-"
                  else
                    text "+"
                ]

        isExpandable =
            case v of
                JsonValue.ObjectValue props ->
                    props |> List.isEmpty |> not

                JsonValue.ArrayValue items ->
                    items |> List.isEmpty |> not

                _ ->
                    False
    in
        div
            [ classList
                [ ( "json-viewer", True )
                , ( "json-viewer__child-value", True )
                ]
            ]
            [ if isExpandable then
                toggle
              else
                text ""
            , span
                [ classList
                    [ ( "json-viewer", True )
                    , ( "json-viewer__key", True )
                    , ( "json-viewer__key--expandable", isExpandable )
                    ]
                , onClick <| Toggle childPath
                ]
                [ text k ]
            , case v of
                JsonValue.ObjectValue props ->
                    props
                        |> List.take 5
                        |> List.map (\( k, _ ) -> k)
                        |> String.join ", "
                        |> (\s ->
                                span
                                    [ class "json-viewer json-viewer--collapsed"
                                    , onClick <| Toggle childPath
                                    ]
                                    [ if List.length props > 5 then
                                        "{ " ++ s ++ ", ... }" |> text
                                      else
                                        "{ " ++ s ++ " }" |> text
                                    ]
                           )

                _ ->
                    text ""
            , v |> viewComponent expandedNodes childPath
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
