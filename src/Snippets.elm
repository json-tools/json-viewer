module Snippets exposing (Snippet(..), getSnippetTitle)


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
