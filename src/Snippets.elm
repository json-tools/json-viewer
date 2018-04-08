module Snippets exposing (Snippet(..), getSnippet, getSnippetTitle)

import JsonValue exposing (JsonValue)
import Json.Encode exposing (object, string, bool, int, null)
import Json.Decode exposing (Value, decodeValue)


type Snippet
    = Traveller


getSnippetTitle : Snippet -> String
getSnippetTitle ds =
    case ds of
        Traveller ->
            "Traveller"


getSnippet : Snippet -> JsonValue
getSnippet ds =
    makeJsonObject <|
        case ds of
            Traveller ->
                [ ( "firstName", string "John" )
                , ( "middleName", null )
                , ( "lastName", string "Doe" )
                , ( "document"
                  , object
                        [ ( "type", string "passport" )
                        , ( "number", string "123456789" )
                        , ( "validUntil", string "2020-08-23" )
                        ]
                  )
                , ( "hasLuggage", bool True )
                , ( "ageAtTimeOfDeparture", int 42 )
                ]


makeJsonObject : List ( String, Value ) -> JsonValue
makeJsonObject v =
    v
        |> object
        |> decodeValue JsonValue.decoder
        |> Result.withDefault JsonValue.NullValue
