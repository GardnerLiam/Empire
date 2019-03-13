class GameState {
  public static final int MENU = 0;
  public static final int GAME = 1;
  public static final int SEED = 2;
  public static final int DEAD = 3;
  public static final int PAUSE = 4;
  
  
  int state;
  int prevState;
  
  public GameState(){
    state = 0;
    prevState = 4;
  }
  
  public int getGameState(){
    return state;    
  }
  
  public int getPrevGameState(){
    return prevState;
  }
  
  public void setGameState(int newGameState){
    prevState = state;
    state = newGameState;
  }
  
  public void setPrevGameState(int newPrev){
    prevState = newPrev;
  }
  
  public void changeState(){
    prevState = state;
    state++;
  }
  
  
}
