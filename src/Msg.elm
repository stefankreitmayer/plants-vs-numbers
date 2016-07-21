module Msg exposing (..)

import Time exposing (Time,second)

import Model exposing (..)
import Model.Ui exposing (..)
import Window
import Task
import AnimationFrame


type Msg
  = ResizeWindow (Int,Int)
  | Tick Time
  | StartGame
  | TimeSecond Time
  | NoOp


subscriptions : Model -> Sub Msg
subscriptions {ui} =
  let
      window = Window.resizes (\{width,height} -> ResizeWindow (width,height))
      animation = [ AnimationFrame.diffs Tick ]
      seconds = Time.every Time.second TimeSecond
  in
     (
     case ui.screen of
       StartScreen ->
         [ window, seconds ]

       PlayScreen ->
         [ window ] ++ animation

       GameoverScreen ->
         [ window ]

     ) |> Sub.batch


initialWindowSizeCommand : Cmd Msg
initialWindowSizeCommand =
  Task.perform (\_ -> NoOp) (\{width,height} -> ResizeWindow (width,height)) Window.size
