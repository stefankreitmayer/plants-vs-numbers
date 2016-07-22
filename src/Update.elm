module Update exposing (..)

import Set exposing (Set)
import Char
import Time exposing (Time)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Scene exposing (..)
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
stepEnemy delta plant enemy =
  let
      enemy' = { enemy | posX = enemy.posX - 0.0001 * delta }
      plant' = { plant | dead = plant.dead || enemy.posX < plant.posX }
  in
      (enemy',plant')
