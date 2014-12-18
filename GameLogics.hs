module GameLogics where

horizontalCellsCount = 10
verticalCellsCount = 10

middleH = horizontalCellsCount `div` 2
middleV = verticalCellsCount `div` 2

matrixIndex row_i col_i col_size = row_i * col_size + col_i

fieldIndex row_i col_i = matrixIndex row_i col_i verticalCellsCount

middleCell = fieldIndex middleH middleV

snake = [middleCell, middleCell - 1, middleCell - 2]

apple = undefined

field snake_l = [paintSnakeCell cell_v | cell_v <- gen_l]
  where
    gen_l = [0 .. (horizontalCellsCount * verticalCellsCount) - 1]
    paintSnakeCell cell_v
      | cell_v == head snake_l = 1
      | elem cell_v snake_l = 2
      | otherwise = 0

