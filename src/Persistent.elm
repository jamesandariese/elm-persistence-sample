module Persistent exposing (..)

{-
Customize your model
-}

type alias Model =
    { counter : Int
    }

modCounter : Int -> Model -> Model
modCounter d m = 
    {m | counter = m.counter + d}

increment : Model -> Model
increment = modCounter 1

decrement : Model -> Model
decrement = modCounter -1


{- ---------------------- -}
{-

Wrap an update function with a batched command that will call the state persisting port

-}

wrapUpdate : (msg -> model -> (model, Cmd msg)) -> (model -> Model) -> (Model -> Cmd msg) -> msg -> model-> ( model, Cmd msg )
wrapUpdate update extractPersistentModel setStorage msg model =
    let (newModel, cmd) =
            update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage (extractPersistentModel newModel), cmd ]
        )

withDefault : Maybe Model -> Model
withDefault maybeModel =
    case maybeModel of
        Nothing ->
            Model 0
        Just m -> m

