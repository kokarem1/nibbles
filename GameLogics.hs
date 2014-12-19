module GameLogics where

import System.Random

horizontalCellsCount = 10
verticalCellsCount = 10
cellsCount = horizontalCellsCount * verticalCellsCount

middleH = horizontalCellsCount `div` 2
middleV = verticalCellsCount `div` 2

matrixIndex row_i col_i col_size = row_i * col_size + col_i

fieldIndex row_i col_i = matrixIndex row_i col_i verticalCellsCount

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

apple snake_l = makeAppleList !! head (randomRs (0,aLength-1) (mkStdGen $ foldl (+) 0 snake_l) :: [Int])
  where
    aLength = cellsCount-(length snake_l)
    makeAppleList = fillAppleList [0..aLength-1] 0
    fillAppleList [] _ = []
    fillAppleList (a:pple) i
       | aLength + i == cellsCount = a:pple
       | (filter (==a) snake_l == []) = a : fillAppleList pple i
       | otherwise = (aLength + i) : fillAppleList pple (i+1)

field snake_l = [paintSnakeCell cell_v | cell_v <- gen_l]
  where
    gen_l = [0 .. cellsCount - 1]
    paintSnakeCell cell_v
      | cell_v == head snake_l = 1
      | elem cell_v snake_l = 2
      | otherwise = 0

