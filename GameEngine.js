var game

var gameOverState = true

var nextGrowing = false

function changeGameState(choice, twoKeys)
{
    var gameNewState = game.setSnake(choice, twoKeys, nextGrowing)

    var headsRowDiff = Math.abs( listRowIndex( game.head() ) - listRowIndex( gameNewState.head() ) )
    var headsColDiff = Math.abs( listColIndex( game.head() ) - listColIndex( gameNewState.head() ) )
    var crashByWall = headsRowDiff > 1 || headsColDiff > 1 || gameNewState.head() < 0 || gameNewState.head() > (cellsCount - 1) 
    
    var crashBySnake = false;
    
    for (var i = 1; i < game.snake.length ; ++i)
      if ( gameNewState.head() == gameNewState.snake[i] )
      {
        crashBySnake = true
        break
      }
        
    
    var gameOverConditions = crashByWall || crashBySnake
    
    if (! gameOverConditions)
    {
      if ( nextGrowing = gameNewState.head() == game.apple() )
      {
        game = gameNewState.genApple()
      }
      else
      {
        game = gameNewState
      }
    }
    else
      gameOverState = true
      
    return gameOverConditions
}

var SCORE_SHIFT = 1;

