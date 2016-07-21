module Model.Scene exposing (..)

import Char exposing (toCode)
import Time exposing (Time)


type alias Scene =
  { dummy : String }

initialScene : Scene
initialScene =
  { dummy = "hello world!" }
