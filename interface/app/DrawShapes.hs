module DrawShapes where

import Raylib.Core.Text (drawText)
import Raylib.Core.Shapes (drawCircle, drawRectangle)

import Raylib.Util.Colors (lightGray, black)

-- Constantes

scale :: Float
scale = 100

radius :: Float
radius = scale/4.0

-- Funções de desenho

-- Calcular as dimensões da janela baseado nos nós mais distantes da origem
getScreenDimensions :: [(String, Int, Int)] -> (Int, Int)
getScreenDimensions treelist = mapTwo (+ floor scale) (getMaxXandY treelist)
    where
        mapTwo :: (a -> b) -> (a, a) -> (b, b)
        mapTwo f (x,y) = (f x, f y)

-- Máximo das coordenadas x e y entre os nós da árvore
getMaxXandY :: [(String, Int, Int)] -> (Int, Int)
getMaxXandY [] = (-1, -1)
getMaxXandY ((_, x, y):xr) = 
    let (maxX, maxY) = getMaxXandY xr
    in
        (max maxX x, max maxY y)

-- Desenhar a árvore
drawTree :: [(String, Int, Int)] -> IO ()
drawTree [] = do return()
drawTree ((key, x, y):xr) = do
    drawCircle x y radius lightGray
    drawText key (x-4) (y-8) 16 black
    drawTree xr

-- Desenhar a "régua" nos cantos da tela
drawRuler :: Int -> Int -> Int -> Int -> Int -> IO ()
drawRuler rulerScale initX initY screenWidth screenHeight = do
    drawRulerX initX
    drawRulerY initY
    where
        drawRulerX initXX
            | initXX > screenWidth = do return()
            | otherwise = do
                drawRectangle initXX (screenHeight-10) 1 10 lightGray
                drawNthText (show initXX) initXX (screenHeight-20) 2 black
                drawRulerX (initXX+rulerScale)
            where
                drawNthText text x y size color
                    | x `mod` floor scale < 10 = do drawText text x y size color
                    | otherwise = do return()
        
        drawRulerY initYY
            | initYY <= 0 = do return()
            | otherwise = do
                drawRectangle 0 initYY 10 1 lightGray
                drawNthText (show initYY) 20 initYY 2 black
                drawRulerY (initYY-rulerScale)
            where
                drawNthText text x y size color
                    | y `mod` floor scale < 10 = do drawText text x y size color
                    | otherwise = do return()
