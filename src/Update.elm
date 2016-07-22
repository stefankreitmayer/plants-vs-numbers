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
stepEnemy delta plant ({posX} as enemy) =
  let
      posX' = posX - 0.0001 * delta
      collided = posX < plant.posX
      (posX'',plant') = if collided && (not (isDead plant)) then
                            (posX'+0.003*delta, {plant | health = plant.health - 1})
                        else
                            (posX',plant)
      enemy' = { enemy | posX = posX'' }
  in
      (enemy',plant')
