module Model.Scene.Enemy exposing (..)

type alias Enemy =
  { number : Int
  , posX : Float
  , velX : Float }


newEnemy : Int -> Enemy
newEnemy number =
  { number = number
  , posX = 1
  , velX = -enemyTopSpeed }


enemyTopSpeed : Float
enemyTopSpeed =
  0.0001


enemyAcceleration : Float
enemyAcceleration =
  -0.0001
