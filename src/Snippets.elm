module Snippets exposing (Snippet(..), getSnippetTitle)

import Json.Viewer
import JsonValue exposing (JsonValue)
import Json.Encode exposing (object, string, bool, int, null)
import Json.Decode exposing (Value, decodeValue)


type Snippet
    = Traveller
    | Countries


getSnippetTitle : Snippet -> String
getSnippetTitle ds =
    case ds of
        Traveller ->
            "Traveller"

        Countries ->
            "Countries"


makeJsonViewer : List ( String, Value ) -> Json.Viewer.Model
makeJsonViewer v =
    v
        |> object
        |> decodeValue JsonValue.decoder
        |> Result.withDefault JsonValue.NullValue
        |> Json.Viewer.init
