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
        , view = \model -> { title = "Elm Partial Persistence Sample", body = [view model] }
        , update = Persistent.wrapUpdate update extractPersistentModel setPersistentState
        , subscriptions = \_ -> Sub.none
        }

type alias Model =
    { persistent : Persistent.Model
    , counter : Int
    }

emptyModel : Persistent.Model -> Model
emptyModel pm =
    { persistent = pm
    , counter = 0
    }
extractPersistentModel : Model -> Persistent.Model
extractPersistentModel m =
    m.persistent

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        Increment ->
            ( {model | counter = model.counter + 1}
            , Cmd.none
            )
        Decrement ->
            ( {model | counter = model.counter - 1}
            , Cmd.none
            )
        IncrementPersistent ->
            ( {model | persistent = (Persistent.increment model.persistent)}
            , Cmd.none
            )
        DecrementPersistent ->
            ( {model | persistent = (Persistent.decrement model.persistent)}
            , Cmd.none
            )
    
type Msg
    = NoOp
    | Increment
    | Decrement
    | IncrementPersistent
    | DecrementPersistent
        
view : Model -> Html Msg
view model =
    div []
        [ div []
              [ text "Temporary "
              , text (String.fromInt model.counter)
              , button [onClick Decrement] [text "-"]
              , button [onClick Increment] [text "+"]
              ]
        , div []
              [ text "Persistent "
              , text (String.fromInt model.persistent.counter)
              , button [onClick DecrementPersistent] [text "-"]
              , button [onClick IncrementPersistent] [text "+"]
              ]
        ]
