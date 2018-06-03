module Main exposing (main)

import Html
import Demo exposing (init, update, view, subscriptions)


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
