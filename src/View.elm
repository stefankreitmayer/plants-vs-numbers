module View exposing (view)

import Html exposing (Html,div)
import Html.Attributes exposing (class)
import Html.Events
import Svg exposing (Svg,Attribute)
import Svg.Attributes as Attributes exposing (x,y,width,height,fill,fontFamily,textAnchor)
import Svg.Events
import Time exposing (Time)
import String

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Scene exposing (..)

import Msg exposing (..)

import View.Enemy exposing (..)
import View.Plant exposing (..)

import VirtualDom
import Json.Encode


view : Model -> Html Msg
view {ui,scene,secondsPassed} =
  case ui.screen of
    StartScreen ->
      renderStartScreen ui.windowSize

    PlayScreen ->
      renderPlayScreen ui.windowSize scene

    GameoverScreen ->
      renderGameoverScreen ui.windowSize


renderStartScreen : (Int,Int) -> Html Msg
renderStartScreen (w,h) =
  let
      heading = Html.h1 [] [ Html.text "Plants vs Numbers" ]
      instructions = Html.p [] [ Html.text "Keep the numbers from crossing the line" ]
      clickHandler = Html.Events.onClick StartGame
      startButton = Html.button [ clickHandler ] [ Html.text "Start" ]
  in
      div [ class "modal" ] [ heading, instructions, startButton ]


renderPlayScreen : (Int,Int) -> Scene -> Html Msg
renderPlayScreen windowSize scene =
  Svg.svg (svgAttributes windowSize)
  [ renderEnemy windowSize scene.enemy
  , renderPlant windowSize scene.plant
  ]


renderGameoverScreen : (Int,Int) -> Html Msg
renderGameoverScreen (w,h) =
  let
      heading = Html.h1 [] [ Html.text "Game over" ]
      clickHandler = Html.Events.onClick StartGame
      restartButton = Html.button [ clickHandler ] [ Html.text "Restart" ]
  in
      div [ class "modal" ] [ heading, restartButton ]


svgAttributes : (Int, Int) -> List (Attribute Msg)
svgAttributes (w, h) =
  [ width (toString w)
  , height (toString h)
  , Attributes.viewBox <| "0 0 " ++ (toString w) ++ " " ++ (toString h)
  , VirtualDom.property "xmlns:xlink" (Json.Encode.string "http://www.w3.org/1999/xlink")
  , Attributes.version "1.1"
  , Attributes.style "position: fixed;"
  ]
