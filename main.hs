{-# LANGUAGE TypeFamilies, DeriveDataTypeable #-}

import Graphics.QML

import Data.Typeable

import GameLogics

data GameObj = GameObj {
  snakeList :: [Int],
  fieldList :: [Int],
  currentRow :: Int,
  currentColumn :: Int,
  direction :: Int,
  applePos :: Int
  }
  deriving Typeable

instance DefaultClass GameObj where
    classMembers = [defPropertyRO "currentRow" getCurrentRow,
                    defPropertyRO "currentColumn" getCurrentColumn,
                    defPropertyRO "field" getField,
                    defPropertyRO "snake" getSnake,
                    defMethod "setCurrentCell" setCurrentCell,
                    defMethod "setSnake" setSnake,
                    defMethod "direction" getDirection,
                    defMethod "head" getHead,
                    defMethod "genApple" genApple,
                    defMethod "apple" getApple,
                    defMethod "field111" generateField,
                    defMethod "aaA" ggG]
    
instance Marshal GameObj where
    type MarshalMode GameObj c d = ModeObjFrom GameObj c
    marshaller = fromMarshaller fromObjRef

getCurrentRow :: GameObj -> IO Int
getCurrentRow gO = return $ (currentRow gO)

getCurrentColumn :: GameObj -> IO Int
getCurrentColumn gO = return $ (currentColumn gO)

getField :: GameObj -> IO [Int]
getField gO = return $ (fieldList gO)

getSnake :: GameObj -> IO [Int]
getSnake gO = return $ (snakeList gO)

getDirection :: GameObj -> IO Int
getDirection gO = return $ (direction gO)

getHead :: GameObj -> IO Int
getHead gO = return $ head (snakeList gO)

getApple :: GameObj -> IO Int
getApple gO = return $ (applePos gO)

genApple :: GameObj -> IO (ObjRef GameObj)
genApple gO = newObjectDC $ gO { snakeList = snakeList gO,
                                 fieldList = fieldList gO,
                                 currentRow = currentRow gO,
                                 currentColumn = currentColumn gO,
                                 direction = direction gO,
                                 applePos = apple (snakeList gO) }

setCurrentCell :: GameObj -> Int -> Int -> IO (ObjRef GameObj)
setCurrentCell gO rowI colI = let snakeL = snakeList gO
                                  fieldL = fieldList gO
                                  i = fieldIndex rowI colI
                                  dir = direction gO
                              in newObjectDC $ gO { snakeList = snakeL,
                                                    fieldList = fieldL,
                                                    currentRow = i,
                                                    currentColumn = i, 
                                                    direction = dir,
                                                    applePos = applePos gO }
  
setSnake :: GameObj -> Int -> Bool -> Bool -> IO (ObjRef GameObj)
setSnake gO shift twoKeysControl growing = let snakeL = moveSnake dir shift (not twoKeysControl) growing (snakeList gO)
                                               fieldL = fieldList gO
                                               curRow = currentRow gO
                                               curCol = currentColumn gO
                                               dir = direction gO
                            in newObjectDC $ gO { snakeList = snakeL,
                                                  fieldList = field snakeL,
                                                  currentRow = curRow,
                                                  currentColumn = curCol,
                                                  direction = if twoKeysControl then newDirection dir shift else newDirection4Keys dir shift,
                                                  applePos = applePos gO }

generateField :: GameObj -> IO (ObjRef GameObj)
generateField gO =
  let snakeL = snakeList gO
  in newObjectDC $ gO { snakeList = [-1,-1,-1],
                        currentRow = snakeL !! 0,
                        currentColumn = snakeL !! 1 }
  
ggG :: GameObj -> IO ()
ggG gO = print ( (snakeList gO) !! 0, (snakeList gO) !! 1 )
  
createGame :: ObjRef () -> IO (ObjRef GameObj)
createGame _ = newObjectDC $ GameObj snake (field snake) 0 0 2 (apple snake)

main :: IO ()
main = do
  clazz <- newClass [defMethod "createGame" createGame,
                     defMethod' "fieldIndex" ( \ _ rowIndex colIndex -> ( return $ fieldIndex rowIndex colIndex ) :: IO Int ),
                     defMethod' "listRowIndex" ( \ _ index -> ( return $ fst $ listIndex index ) :: IO Int ),
                     defMethod' "listColIndex" ( \ _ index -> ( return $ snd $ listIndex index ) :: IO Int ),
                     defPropertyConst' "horizontalCellsCount" ( \ _ -> (return horizontalCellsCount) :: IO Int ),
                     defPropertyConst' "verticalCellsCount" ( \ _ -> (return verticalCellsCount) :: IO Int ),
                     defPropertyConst' "cellsCount" ( \ _ -> (return cellsCount) :: IO Int ) ]
  
  ctx <- newObject clazz ()
  runEngineLoop defaultEngineConfig {
    initialDocument = fileDocument "Nibbles.qml",
    contextObject = Just $ anyObjRef ctx
  }

