port module Main exposing (..)

import Browser
import Browser.Dom as Dom
import Persistent
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

port setPersistentState : Persistent.Model -> Cmd msg
                    
init : Maybe Persistent.Model -> ( Model, Cmd Msg )
init maybePersistentModel =
  ( emptyModel (Persistent.withDefault maybePersistentModel)
  , Cmd.none
  )

main : Program (Maybe Persistent.Model) Model Msg
main =
    Browser.document
        { init = init
        , view = \model -> { title = "Elm Partial Persistence Sample Reset", body = [view model] }
        , update = Persistent.wrapUpdate update extractPersistentModel setPersistentState
        , subscriptions = \_ -> Sub.none
        }

type alias Model =
    { persistent : Persistent.Model
    }

emptyModel : Persistent.Model -> Model
emptyModel pm =
    { persistent = pm
    }
extractPersistentModel : Model -> Persistent.Model
extractPersistentModel m =
    m.persistent

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        ResetPersistent ->
            ( {model | persistent = (Persistent.withDefault Nothing)}
            , Cmd.none
            )
    
type Msg
    = NoOp
    | ResetPersistent
        
view : Model -> Html Msg
view model =
    div []
        [ div []
              [ text "Temporary counter is reset.  Persistent counter is "
              , text (String.fromInt model.persistent.counter)
              , button [onClick ResetPersistent] [text "Reset Persistent"]
              ]
        , div []
              [ a [ href "index.html" ]
                    [ text "Done"
                    ]
              ]
        ]
