module Snippets exposing (Snippet(..), getSnippetTitle)


type Snippet
    = Traveller
    | Countries
    | Addresses


getSnippetTitle : Snippet -> String
getSnippetTitle ds =
    case ds of
        Traveller ->
            "Traveller"

        Countries ->
            "Countries"

        Addresses ->
            "Addresses"
