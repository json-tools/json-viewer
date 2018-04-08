module Main exposing (main)

import Html
import Demo exposing (init, update, view)


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
