module Model.Scene exposing (..)

import Char exposing (toCode)
import Time exposing (Time)


import Model.Scene.Enemy exposing (..)
import Model.Scene.Plant exposing (..)


type alias Scene =
  { enemy : Enemy
  , plant : Plant }


initialScene : Scene
initialScene =
  { enemy = newEnemy 5
  , plant = newPlant }
