import Data.Array
import Data.Array.ST
import Data.Array.MArray

horizontalCellsCount = 10
verticalCellsCount = 10

middleH = horizontalCellsCount `div` 2
middleV = verticalCellsCount `div` 2

matrixIndex row_i col_i col_size = row_i * col_size + col_i

middleCell = matrixIndex middleH middleV verticalCellsCount

snake = [middleCell, middleCell - 1, middleCell - 2]

apple = undefined

field snake_l = elems $ runSTArray $ do
  let list0 = (take (horizontalCellsCount * verticalCellsCount) $ repeat 0)
  arr <- newListArray (0, length list0 - 1) list0
  writeArray arr middleCell 1
  return arr
