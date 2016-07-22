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
          enemy' = scene.enemy |> stepEnemy delta
          isGameOver = enemy'.posX <= 0
          screen' =
            if isGameOver then
                GameoverScreen
            else
                PlayScreen
          scene' = { scene | enemy = enemy' }
          ui' = { ui | screen = screen' }
      in
          ({ model | scene = scene', ui = ui' }, Cmd.none)

    StartGame ->
      (freshGame ui, Cmd.none)

    TimeSecond _ ->
      ({ model | secondsPassed = model.secondsPassed+1 }, Cmd.none)

    NoOp ->
      (model, Cmd.none)


stepEnemy : Time -> Enemy -> Enemy
stepEnemy delta enemy =
  { enemy | posX = enemy.posX - 0.0001 * delta }
