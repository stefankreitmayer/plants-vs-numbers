module Update exposing (..)

import Set exposing (Set)
import Char
import Time exposing (Time)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Scene exposing (..)
import Model.Scene.Enemy exposing (..)
import Model.Scene.Plant exposing (..)
import Msg exposing (..)

import Debug exposing (log)


update : Msg -> Model -> (Model, Cmd Msg)
update action ({ui,scene} as model) =
  case action of
    ResizeWindow dimensions ->
      ({ model | ui = { ui | windowSize = dimensions } }, Cmd.none)

    Tick delta ->
      let
          (enemy',plant') = scene.enemy |> stepEnemy delta scene.plant
          isGameOver = enemy'.posX <= 0
          screen' =
            if isGameOver then
                GameoverScreen
            else
                PlayScreen
          scene' = { scene
                   | enemy = enemy'
                   , plant = plant' }
          ui' = { ui | screen = screen' }
      in
          ({ model | scene = scene', ui = ui' }, Cmd.none)

    StartGame ->
      (freshGame ui, Cmd.none)

    TimeSecond _ ->
      ({ model | secondsPassed = model.secondsPassed+1 }, Cmd.none)

    NoOp ->
      (model, Cmd.none)


stepEnemy : Time -> Plant -> Enemy -> (Enemy,Plant)
stepEnemy delta plant ({posX,velX} as enemy) =
  let
      velX' = velX + enemyAcceleration |> max -enemyTopSpeed
      posX' = posX + velX * delta
      hit = posX < plant.posX && not (isDead plant)
      plant' = if hit then {plant | health = plant.health - 1} else plant
      (posX'',velX'') = if hit && not (isDead plant') then
                            ( plant.posX+enemyTopSpeed*delta
                            , enemyTopSpeed * 10)
                        else
                            (posX',velX')
      enemy' = { enemy
               | posX = posX''
               , velX = velX'' }
  in
      (enemy',plant')
