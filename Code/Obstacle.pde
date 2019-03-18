class Obstacle {
  float x;
  float y;

  float r;
  
  int killCount;

  public Obstacle(){
    x = floor(random(minVal.x + 50, maxVal.x - 50));
    y = floor(random(minVal.y + 50, maxVal.y - 50));
    r = floor(random(10,25));
    killCount = 0;
  }

  void collision(Cell c) {
    if (dist(c.x, c.y, x, y) < r && c.plagued == false) {
      c.isDead = true;
      killCount++;
    }
  }
  
  int getKillCount(){
    return killCount;
  }
  
  void display(){
    pushMatrix();
    fill(0);
    noStroke();
    ellipseMode(CENTER);
    circle(x,y,r);
    popMatrix();
  }
}
