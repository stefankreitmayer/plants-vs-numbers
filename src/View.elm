module View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Svg exposing (Svg,Attribute)
import Svg.Attributes as Attributes exposing (x,y,width,height,fill,fontFamily,textAnchor)
import Svg.Events exposing (onClick)
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
      renderStartScreen ui.windowSize secondsPassed

    PlayScreen ->
      renderPlayScreen ui.windowSize scene

    GameoverScreen ->
      renderGameoverScreen ui.windowSize


renderStartScreen : (Int,Int) -> Int -> Html.Html Msg
renderStartScreen (w,h) secondsPassed =
  let
      clickHandler = onClick StartGame
      screenAttrs = [ clickHandler ] ++ (svgAttributes (w,h))
      title = largeText w h (h//5) "Plants vs Numbers"
      clickToStart = smallText w h (h*4//5) "Click to start"
      children = [ title, clickToStart ]
  in
      Svg.svg
        screenAttrs
        children


renderPlayScreen : (Int,Int) -> Scene -> Html.Html Msg
renderPlayScreen (w,h) scene =
  let
      windowSize = (w,h)
  in
     Svg.svg (svgAttributes windowSize)
     [ renderTextLine (w//2) (h//5) ((normalFontSize w h)*2) "middle" scene.dummy []
     ]


renderGameoverScreen : (Int,Int) -> Html.Html Msg
renderGameoverScreen (w,h) =
  let
      endText = largeText w h (h//3) "Game over"
      restartText = smallText w h (h//2) "Press SPACE to restart"
      children = [ endText , restartText ]
  in
      Svg.svg
        (svgAttributes (w,h))
        children


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
