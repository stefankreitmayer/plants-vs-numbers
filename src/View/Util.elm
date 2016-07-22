module View.Util exposing (..)

import Svg exposing (Svg,Attribute)
import Svg.Attributes as Attributes exposing (x,y,width,height,fill,fontFamily,textAnchor)

import Msg exposing (..)

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
