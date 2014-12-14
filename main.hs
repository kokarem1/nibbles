import Graphics.QML

main :: IO ()
main = do
  clazz <- newClass []
  ctx <- newObject clazz ()
  runEngineLoop defaultEngineConfig {
    initialDocument = fileDocument "Nibbles.qml",
    contextObject = Just $ anyObjRef ctx
  }

