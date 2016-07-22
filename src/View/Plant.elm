module View.Plant exposing (..)

import String
import Debug exposing (log)

import Svg exposing (Svg)
import Svg.Attributes as Attributes exposing (fill,stroke)

import Model.Scene.Plant exposing (..)
import View.Util exposing (..)

import Msg exposing (..)


renderPlant : (Int,Int) -> Plant -> Svg Msg
renderPlant (w,h) ({posX,health} as plant) =
  let
      x = plant.posX * (toFloat w)
      y = (toFloat h)/2
      height = if isDead plant then 9 else (toFloat h)/20
      stalk = renderStalk x y height plant
  in
      stalk


renderStalk : Float -> Float -> Float -> Plant -> Svg Msg
renderStalk x y height plant =
  let
      crookedness = plantInitialHealth - plant.health + 1
      nPoints = 10
      points =
        [0..nPoints]
        |> List.map (\i -> (toFloat i)/nPoints)
        |> List.map (\phase -> stalkPoint x y height crookedness phase)
  in
      Svg.polyline
        [ fill "none"
        , stroke mediumWhite
        , Attributes.points (pointsToString points) ]
        []


stalkPoint : Float -> Float -> Float -> Int -> Float -> (Float,Float)
stalkPoint baseX baseY height crookedness phase =
  let
      c = phase
      x = baseX - height/5 * (phase*pi*(toFloat crookedness) |> sin)
      y = baseY - height * phase
  in
      (x,y)


pointsToString : List (Float,Float) -> String
pointsToString points =
  points
  |> List.map (\(x,y) -> (toString x) ++ "," ++ (toString y))
  |> String.join " "
