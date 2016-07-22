module View.Enemy exposing (..)

import Svg exposing (Svg)

import Model.Scene.Enemy exposing (..)
import View.Util exposing (..)

import Msg exposing (..)

renderEnemy : (Int,Int) -> Enemy -> Svg Msg
renderEnemy (w,h) enemy =
  renderTextLine ((toFloat w)*enemy.posX |> floor) (h//2) (w//20) "middle" (toString enemy.number) []
