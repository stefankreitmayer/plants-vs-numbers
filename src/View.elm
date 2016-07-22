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

import VirtualDom
import Json.Encode as Json


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


renderEnemy : (Int,Int) -> Enemy -> Svg Msg
renderEnemy (w,h) enemy =
  renderTextLine ((toFloat w)*enemy.posX |> floor) (h//2) (w//20) "middle" (toString enemy.number) []


renderPlant : (Int,Int) -> Plant -> Svg Msg
renderPlant (w,h) ({posX,health} as plant) =
  let
      sprite = if isDead plant then "_" else "P"
  in
    renderTextLine ((toFloat w)*plant.posX |> floor) (h//2) (w//20) "middle" sprite []


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
  , VirtualDom.property "xmlns:xlink" (Json.string "http://www.w3.org/1999/xlink")
  , Attributes.version "1.1"
  , Attributes.style "position: fixed;"
  ]


softWhite : String
softWhite = "rgba(255,255,255,.3)"


mediumWhite : String
mediumWhite = "rgba(255,255,255,.6)"


normalFontFamily : String
normalFontFamily =
  "Courier New, Courier, Monaco, monospace"


normalFontSize : Int -> Int -> Int
normalFontSize w h =
  (min w h) // 20 |> min 24


normalLineHeight : Int -> Int -> Int
normalLineHeight w h =
  (toFloat (normalFontSize w h)) * 1.38 |> floor


largeText : Int -> Int -> Int -> String -> Svg Msg
largeText w h y str =
  renderTextLine (w//2) y ((normalFontSize w h)*2) "middle" str []


smallText : Int -> Int -> Int -> String -> Svg Msg
smallText w h y str =
  renderTextLine (w//2) y (normalFontSize w h) "middle" str []


renderTextParagraph : Int -> Int -> Int -> String -> List String -> List (Svg.Attribute Msg) -> Svg Msg
renderTextParagraph xPos yPos fontSize anchor lines extraAttrs =
  List.indexedMap (\index line -> renderTextLine xPos (yPos+index*fontSize*5//4) fontSize anchor line extraAttrs) lines
  |> Svg.g []


renderTextLine : Int -> Int -> Int -> String -> String -> List (Svg.Attribute Msg) -> Svg Msg
renderTextLine xPos yPos fontSize anchor content extraAttrs =
  let
      attributes = [ x <| toString xPos
                   , y <| toString yPos
                   , textAnchor anchor
                   , fontFamily normalFontFamily
                   , Attributes.fontSize (toString fontSize)
                   , fill mediumWhite
                   ]
                   |> List.append extraAttrs
  in
      Svg.text' attributes [ Svg.text content ]
