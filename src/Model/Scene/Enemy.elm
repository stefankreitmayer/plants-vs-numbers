module Model.Scene.Enemy exposing (..)

type alias Enemy =
  { number : Int
  , posX : Float }


newEnemy : Int -> Enemy
newEnemy number =
  { number = number
  , posX = 1 }
