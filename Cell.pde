class Cell {
  float x;
  float y;
  int life;
  float[] movement;
  float strength;
  float col;
  float birthPercent;
  boolean isDead;

  boolean plagued;
  int deathNote;

  float dispersionTime;

  public Cell(float c) {
    x = random(width);
    y = random(height);
    life = 0;
    strength = random(0, 1);
    col = c;
    movement = new float[lifespan];
    birthPercent = initialBirthPercentage;
    isDead = false;

    plagued = false;
    deathNote = 0;
    dispersionTime = 0;
    for (int i = 0; i < lifespan; i++) {
      movement[i] = random(0, TWO_PI+0.01);
    }
  }

  public Cell(float c, float[] mov) {
    x = random(width);
    y = random(height);
    life = 0;
    strength = random(0, 1);
    col = c;
    movement = mov;
    birthPercent = initialBirthPercentage;
    isDead = false;
    dispersionTime = 0;
    plagued = false;
    deathNote = 0;
  }

  void move(ArrayList<Cell> cells) {
    if (!plagued) {
      PVector decision = PVector.fromAngle(movement[life]);
      decision.setMag(1);
      x += decision.x;
      y += decision.y;
      if (dispersionTime > 0) {
        if (life > 0.60*lifespan) {
          isDead = true;
        }
        if (random(0, 1) > 0.5) {
          x += dispersionStrength;
        } else {
          x -= dispersionStrength;
        }
        if (random(0, 1) > 0.5) {
          y += dispersionStrength;
        } else {
          y -= dispersionStrength;
        }
        dispersionTime+= 1/60f;
      }
      if (x < minVal.x) {
        x = maxVal.x - 10;
      } else if (x > maxVal.x) {
        x = minVal.x + 10;
      }

      if (y < minVal.y) {
        y = maxVal.y - 10;
      } else if (y > maxVal.y) {
        y = minVal.y + 10;
      }
      if (dispersionTime > 4000000) {
        dispersionTime = 0;
      }
      life += 1;
      for (int i = cells.size()-1; i >= 0; i--) {
        Cell c = cells.get(i); 
        if (c != this) {
          if (checkRadius(x, y, c.x, c.y) && (col%127)+127 != (c.col%127)+127) {
            if (strength > c.strength) {
              cells.remove(c);
            } else if (strength < c.strength) {
              isDead = true;
            }
          }
        }
      }

      if (life >= lifespan) {
        isDead = true;
      }
      if (life > lifespan/2  && random(0, 1) < birthPercent && cells.size() < maxSize) {
        cells.add(birth());
      }
    } else {
      if (deathNote < 120) {
        deathNote ++;
      } else {
        isDead = true;
      }
    }
  }

  String toString() {
    return "[" + x + " " + y + "] life --> " + life + " strength --> " + strength + " col --> " + col;
  }

  boolean checkRadius(float x1, float y1, float x2, float y2) {
    return dist(x1, y1, x2, y2) <= size*radius;
  }

  Cell birth() {
    Cell c = new Cell(col, movement);
    c.x = x + random(10, 10);
    c.y = y + random(-10, 10);
    if (random(0, 1) < colStartPercentage) {
      c.col = random(0, 32)*8;
      for (int i = 0; i < colSize; i++) {
        while (abs(c.col - colonies.get(i)) < cthresh) {
          c.col = random(0, 32)*8;
        }
      }
      colonies.add(c.col);
      colSize++;
    }
    for (int i = 0; i < lifespan; i++) {
      if (random(0, 1) < movement_mutation_rate) {
        if (random(0,1) > 0.5){
          c.movement[i] = random(1.58, TWO_PI+0.01);
        }else{
          c.movement[i] = random(0, TWO_PI+0.01);
        }
      }
    }
    if (random(0, 1) < 0.1) {
      if (random(0, 1) > 0.5) {
        c.strength = strength + 0.1;
      } else {
        c.strength = strength - 0.1;
        if (c.strength < 0.1){
          c.strength = 0.1;
        }
      }
    } else {
      c.strength = strength;
    }
    if (random(0, 1) < 0.1) {
      if (random(0, 1) > 0.5) {
        c.birthPercent += 0.025;
      }else{ 
        c.birthPercent -= 0.025;
      }
    }
    return c;
  }
}
