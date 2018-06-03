module Json.Viewer exposing (Model, Msg, init, update, view)

{-|
@docs Model, Msg, init, update, view
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Value as JsonValue exposing (JsonValue)


{-|
Local state of Json.Viewer component. Usage example:

    type alias Model =
        { jsonViewer : Json.Viewer.Model
        , {- ...the rest of your app model decraration -}
        }
-}
type Model
    = Model
        { expandedNodes : List Path
        , jsonValue : JsonValue
        }


{-|
Local messages of Json.Viewer component. Usage example:

    type Msg
        = JsonViewerMsg Json.Viewer.Msg
        | {- ...the rest of your app messages -}

-}
type Msg
    = Toggle Path


type alias Path =
    List String


{-|
Initialization of Json.Viewer component. Usage example:

    init : ( Model, Cmd Msg)
    init =
        { jsonViewer: Json.Viewer.init Json.Value.NullValue
        , {- ...the rest of your app state initialization -}
        } ! []

-}
init : JsonValue -> Model
init jsonValue =
    Model { expandedNodes = [], jsonValue = jsonValue }


{-|
Toggle expandable node. Usage example:

    update msg model =
        case msg of
            JsonViewerMsg m ->
                { model
                    | jsonViewer =
                        model.jsonViewer |> update m
                } ! []

            {- ...the rest of your app message handling -}

-}
update : Msg -> Model -> Model
update msg (Model model) =
    case msg of
        Toggle path ->
            if List.member path model.expandedNodes then
                Model { model | expandedNodes = model.expandedNodes |> List.filter ((/=) path) }
            else
                Model { model | expandedNodes = path :: model.expandedNodes }


{-|
Render JsonViewer. Usage example:

    view: Model -> Html Msg
    view model=
        model.jsonViewer
            |> Json.Viewer.view
            |> Html.map JsonViewerMsg
-}
view : Model -> Html Msg
view (Model model) =
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
