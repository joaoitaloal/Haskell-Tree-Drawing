{-# LANGUAGE TemplateHaskell #-}
module Main where

import Raylib.Core (clearBackground, initWindow, setTargetFPS, windowShouldClose, closeWindow)
import Raylib.Util (drawing, raylibApplication, WindowResources)
import Raylib.Util.Colors (rayWhite)

import TreeCoords ( toTreeCoords, treeCoordsToList, tree2 )
import DrawShapes ( getScreenDimensions, drawTree, drawRuler, scale )

-- Inicializando e calculando estruturas

treelist :: [(String, Int, Int)]
treelist = treeCoordsToList (toTreeCoords tree2 (floor scale))

screenWidth::Int; screenHeight:: Int;
(screenWidth, screenHeight) = getScreenDimensions treelist

-- Startup da raylib

startup :: IO WindowResources
startup = do
  window <- initWindow screenWidth screenHeight "Draw Tree"
  setTargetFPS 60
  print treelist
  return window

mainLoop :: WindowResources -> IO WindowResources
mainLoop window =
  drawing
    ( do
        clearBackground rayWhite
        drawTree treelist -- desenhar a árvore e a régua
        drawRuler 10 0 (screenHeight-5) screenWidth screenHeight
    ) >> return window

shouldClose :: WindowResources -> IO Bool
shouldClose _ = windowShouldClose

teardown :: WindowResources -> IO ()
teardown = closeWindow . Just

$(raylibApplication 'startup 'mainLoop 'shouldClose 'teardown)
