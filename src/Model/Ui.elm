module Model.Ui exposing (..)

import Set exposing (Set)

import Model.Scene exposing (..)


type alias Ui =
  { windowSize : (Int, Int)
  , screen : Screen }


type Screen = StartScreen | PlayScreen | GameoverScreen

initialUi : Ui
initialUi =
  { windowSize = (320,320)
  , screen = StartScreen }
