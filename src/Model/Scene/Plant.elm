module Model.Scene.Plant exposing (..)

type alias Plant =
  { posX : Float
  , health : Int }


newPlant : Plant
newPlant =
  { posX = 0.8
  , health = 3 }


isDead : Plant -> Bool
isDead {health} =
  health <= 0
