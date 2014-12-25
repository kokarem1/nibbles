module GameLogics where

import System.Random
import System.IO.Unsafe

horizontalCellsCount = 10
verticalCellsCount = 10
cellsCount = horizontalCellsCount * verticalCellsCount

middleH = horizontalCellsCount `div` 2
middleV = verticalCellsCount `div` 2

matrixIndex row_i col_i col_size = row_i * col_size + col_i

fieldIndex row_i col_i = matrixIndex row_i col_i verticalCellsCount

listIndex i = (i `div` verticalCellsCount, i `rem` verticalCellsCount)

middleCell = fieldIndex middleH middleV

snake = [middleCell, middleCell - 1, middleCell - 2]

newDirection direction shift = case shift of
                                 0 -> direction
                                 1 -> case direction of
                                        1 -> 2
                                        2 -> 3
                                        3 -> 4
                                        4 -> 1
                                 2 -> case direction of
                                        1 -> 4
                                        2 -> 1
                                        3 -> 2
                                        4 -> 3

moveSnake direction shift growing snake_l = do
  let snakeTail = take (length snake_l - 1) snake_l
  let snakeHead = head snake_l
  let row_i = fst $ listIndex snakeHead
  let col_i = snd $ listIndex snakeHead
  let finalDirection = newDirection direction shift
  let snakeNewHead = case finalDirection of
                       1 -> fieldIndex (row_i - 1) col_i
                       2 -> fieldIndex row_i (col_i + 1)
                       3 -> fieldIndex (row_i + 1) col_i
                       4 -> fieldIndex row_i (col_i - 1)
  if growing then [snakeNewHead]++snake_l else [snakeNewHead]++snakeTail

apple snake_l = makeAppleList !! randomMy (aLength-1)
  where
    randomMy leng = unsafePerformIO (randomRIO(0,leng))
    aLength = cellsCount-(length snake_l)
    makeAppleList = fillAppleList [0..cellsCount-1]
    fillAppleList [] = []
    fillAppleList (a:pple)
       | (filter (==a) snake_l == []) = a : fillAppleList pple
       | otherwise = fillAppleList pple

field snake_l = [paintSnakeCell cell_v | cell_v <- gen_l]
  where
    gen_l = [0 .. cellsCount - 1]
    paintSnakeCell cell_v
      | cell_v == head snake_l = 1
      | elem cell_v snake_l = 2
      | otherwise = 0

