module Model.Scene exposing (..)

import Char exposing (toCode)
import Time exposing (Time)


type alias Scene =
  { enemy : Enemy
  , plant : Plant }

type alias Enemy =
  { number : Int
  , posX : Float }

type alias Plant =
  { posX : Float
  , dead : Bool }


initialScene : Scene
initialScene =
  { enemy = newEnemy 5
  , plant = newPlant }


newEnemy : Int -> Enemy
newEnemy number =
  { number = number
  , posX = 1 }


newPlant : Plant
newPlant =
  { posX = 0.8
  , dead = False }
