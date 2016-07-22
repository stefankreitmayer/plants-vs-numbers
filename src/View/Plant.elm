module View.Plant exposing (..)

import Svg exposing (Svg)

import Model.Scene.Plant exposing (..)
import View.Util exposing (..)

import Msg exposing (..)


renderPlant : (Int,Int) -> Plant -> Svg Msg
renderPlant (w,h) ({posX,health} as plant) =
  let
      sprite = if isDead plant then "_" else "P"
  in
    renderTextLine ((toFloat w)*plant.posX |> floor) (h//2) (w//20) "middle" sprite []
