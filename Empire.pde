/*
TODO: 
 Fix population display drawing --> This'll probably never get done :P
 */

float size = 1;
float maxSize = 1750;
ArrayList<Cell> cells;
int lifespan = 50;
PVector minVal;
PVector maxVal;
float time = 0;

int start = 15;
int colSize = start;
float threshold = 250;
float radius = 5;
float initialBirthPercentage = 0.05;

float movement_mutation_rate = 0.01;

long seed = 0;

float lastVal = -1;

ArrayList<Float> colonies;

int cthresh = 16;

float colStartPercentage = 0.001;

boolean recordMode = true;
boolean showMouse = false;

float plaguePercent = 0.0005;
float dispersionPercent = 0.001;
float dispersionStrength = 10;

float c = 0;
float d = 0;
float plague_strength = 0;

int minDisp = 3;

int obstacleAmount = -1;

Obstacle[] obstacles;

GameState state = new GameState();

String seedDisp = "";

float timeStart = 0;

int KC = -1;

void init(long s) {
  seed = s;
  randomSeed(seed);
  colonies = new ArrayList<Float>();
  for (int i = 0; i < start; i++) {
    colonies.add(random(0, 32)*8);
    if (i > 0) {
      for (int j = 0; j < i; j++) {
        while (abs(colonies.get(i) - colonies.get(j)) < cthresh) {
          colonies.set(i, random(0, 32)*8);
        }
      }
    }
  }

  colorMode(HSB);
  minVal = new PVector(threshold, threshold);
  maxVal = new PVector(width-threshold, height-threshold);

  cells = new ArrayList<Cell>();
  for (int i = 0; i < start; i++) {
    cells.add(new Cell(colonies.get(i)));
  }

  if (obstacleAmount == -1) {
    obstacleAmount = floor(random(1, 50));
  }

  obstacles = new Obstacle[obstacleAmount];

  for (int i = 0; i < obstacleAmount; i++) {
    obstacles[i] = new Obstacle();
  }
}

void setup() {
  //state.changeState();
  randomSeed(seed);
  fullScreen();
  //size(900,700);

  noCursor();
}

void drawBoundaries() {
  pushMatrix();
  rectMode(CORNERS);
  strokeWeight(1);
  noFill();
  colorMode(RGB);
  stroke(150);
  rect(minVal.x, minVal.y, maxVal.x, maxVal.y);
  noStroke();
  fill(50);
  rect(minVal.x+1, minVal.y+1, maxVal.x-1, maxVal.y-1);
  popMatrix();
}

void info() {
  int shift = 0;
  if (recordMode) {
    shift = 60;
  }
  float[] highest = new float[] {0, 0, 0, 0};
  float[] lowest = new float[] {100000, 0, maxSize+100, 0};

  pushMatrix();
  fill(255);
  textSize(24);
  text("Population: " + cells.size() + "/"+floor(maxSize), 10, 30+shift);
  text("Time: " + round((millis()-timeStart)/100)/10f + "s", 10, 90+shift);
  text("Obstacles: " + obstacleAmount, 10, 130+shift);
  text("Seed: " + seed, 10, 170+shift);

  if (KC != -1) {
    text("Kill Count: " + KC, 10, 210+shift);
  }

  if (c > 0) {
    fill(map(c, 0, 1, 0, 255));
    text("A plague has occured with a strength of " + floor(plague_strength), maxVal.x-485, minVal.y-(75-map(c, 0, 1, 0, 100)));
    c-=0.01;
  }

  if (d > 0) {
    fill(map(d, 0, 1, 0, 255));
    text("Dispersion has occured", maxVal.x-300, minVal.y-(100-map(d, 0, 1, 0, 100)));
    d-=0.01;
  }

  rectMode(CORNER);
  colorMode(HSB);
  int s = 30;
  int ystart = 250+shift;
  for (int i = 0; i < colSize; i++) {
    noStroke();
    fill(colonies.get(i)%256, 255, 255);
    if (count(colonies.get(i)) > minDisp) {
      rect(10, ystart+(i*s), 50, 25);
      fill(255);
      text(count(colonies.get(i))+" : "+getAverageStrength(colonies.get(i)), 75, ystart+(i*s)+20);
    }
    if (getAverageStrength(colonies.get(i)) > highest[0] && count(colonies.get(i)) > minDisp) {
      highest[0] = getAverageStrength(colonies.get(i));
      highest[1] = colonies.get(i);
    }
    if (getAverageStrength(colonies.get(i)) < lowest[0]  && count(colonies.get(i)) > minDisp) {
      lowest[0] = getAverageStrength(colonies.get(i));
      lowest[1] = colonies.get(i);
    }

    if (count(colonies.get(i)) > highest[2]) {
      highest[2] = count(colonies.get(i));
      highest[3] = colonies.get(i);
    }
    if (count(colonies.get(i)) < lowest[2] && count(colonies.get(i)) > minDisp) {
      lowest[2] = count(colonies.get(i));
      lowest[3] = colonies.get(i);
    }
  }
  fill(255);
  if (count(highest[1]) > minDisp) {
    text("Highest Strength ("+highest[0]+")", minVal.x+75, maxVal.y+70);
    fill(highest[1]%256, 255, 255);
    rect(minVal.x, maxVal.y+50, 50, 25);
  }
  fill(255);
  if (count(lowest[1]) > minDisp) {
    text("Lowest Strength ("+lowest[0]+")", minVal.x+75, maxVal.y+120);
    fill(lowest[1]%256, 255, 255);
    rect(minVal.x, maxVal.y+100, 50, 25);
  }
  fill(255);
  if (count(highest[3]) > minDisp) {
    text("Highest Population ("+highest[2]+")", maxVal.x-325, maxVal.y+70);
    fill(highest[3]%256, 255, 255);
    rect(maxVal.x-400, maxVal.y+50, 50, 25);
  }
  fill(255);
  if (count(lowest[3]) > minDisp) {
    text("Lowest Population ("+lowest[2]+")", maxVal.x-325, maxVal.y+120);
    fill(lowest[3]%256, 255, 255);
    rect(maxVal.x-400, maxVal.y+100, 50, 25);
  }

  for (int i = colSize-1; i >= 0; i--) {
    if (count(colonies.get(i)) == 0) {
      remCol(colonies.get(i));
    }
  }
  popMatrix();
}

void plague() {
  if (random(0, 1) < plaguePercent && cells.size() > maxSize/2) {
    c = 1;
    float highest = 0;
    float pop = 0;
    for (int i = 0; i < colSize; i++) {
      if (count(colonies.get(i)) > highest) {
        highest = count(colonies.get(i));
        pop = colonies.get(i);
      }
    }
    int percentage = round(random(1, 10));
    plague_strength = percentage;
    int newPop = floor(highest*(100-percentage)/100);
    for (int i = cells.size()-1; i >= 0; i--) {
      if (cells.get(i).col == pop) {
        if (newPop > 0) {
          cells.get(i).plagued = true;
          newPop--;
        }
      }
    }
  }
}

void disperse() {
  if (random(0, 1) < dispersionPercent && cells.size() > maxSize/2) {
    d = 1;
    for (Cell c : cells) {
      c.dispersionTime = 1/60f;
      //c.x += random(-dispersionStrength, dispersionStrength);
      //c.y += random(-dispersionStrength, dispersionStrength);
    }
  }
}

void update() {
  colorMode(HSB);
  plague();
  disperse();
  loadPixels();
  //println(cells.size());
  for (int i = cells.size()-1; i >= 0; i--) {
    try {
      for (Obstacle o : obstacles) {
        o.collision(cells.get(i));
      }
      cells.get(i).move(cells);
      int index = floor(cells.get(i).x) + floor(cells.get(i).y) * width;
      if (cells.get(i).plagued) {
        pixels[index] = color(cells.get(i).col%256, 255, 0);
      } else {
        pixels[index] = color(cells.get(i).col%256, 255, 255);
      }
      if (cells.get(i).isDead) {
        cells.remove(i);
      }
    }
    catch (Exception e) {
      //e.printStackTrace();
    }
  }
  updatePixels();
  boolean k = false;
  for (Obstacle o : obstacles) {
    o.display();
    if (dist(mouseX, mouseY, o.x, o.y) < o.r) {
      KC = o.getKillCount();
      k = true;
    }
  }
  if (!k) {
    KC = -1;
  }
}

void drawButton(String text, float x, float y, float w, float h, float c1, float c2, float c3, float textSize, float textLocX, float textLocY) {
  stroke(c1);
  fill(c2);
  rect(x, y, w, h);
  fill(c3);
  textSize(textSize);
  text(text, textLocX, textLocY);
}

void draw() {
  if (state.getGameState() == GameState.MENU) {
    background(50);
    cursor();

    drawButton("Set Seed", width/2+100, height/2-30, 200, 30, 150, 200, 0, 24, width/2+150, height/2-5);

    if (mouseX > width/2-350 && mouseX < width/2-150 && mouseY > height/2-30 && mouseY < height/2) {
      if (mousePressed) {
        init(millis());
        state.changeState();
        timeStart = millis();
      }
      drawButton("Random Seed", width/2-350, height/2-30, 200, 30, 150, 200, 0, 24, width/2-330, height/2-5);
    } else {
      drawButton("Random Seed", width/2-350, height/2-30, 200, 30, 100, 150, 0, 24, width/2-330, height/2-5);
    }

    if (mouseX > width/2+100 && mouseX < width/2+300 && mouseY > height/2-30 && mouseY < height/2) {
      if (mousePressed) {
        state.setGameState(GameState.SEED);
      }
      drawButton("Set Seed", width/2+100, height/2-30, 200, 30, 150, 200, 0, 24, width/2+150, height/2-5);
    } else {
      drawButton("Set Seed", width/2+100, height/2-30, 200, 30, 100, 150, 0, 24, width/2+150, height/2-5);
    }
  } else if (state.getGameState() == GameState.GAME) {
    background(50);
    info();
    if (!showMouse) {
      noCursor();
    }
    //println(time);
    frameRate(60);
    time += 1/60f;
    if (cells.size() == 0) {
      state.setGameState(GameState.DEAD);
    } else {
      drawBoundaries();
      update();
    }
  } else if (state.getGameState() == GameState.SEED) {
    background(50);
    fill(255);
    text("Enter seed: " + seedDisp, width/2-(100+seedDisp.length()), height/2);
  } else if (state.getGameState() == GameState.DEAD) {
    background(50);
    fill(255);
    textSize(50);
    text("Everyone Died", 100, 100);
    drawBoundaries();
    //noLoop();
  }
}

int count(float val) {
  int counter = 0;
  for (Cell c : cells) {
    if (c.col == val && c.deathNote <= 0) {
      counter++;
    }
  }
  return counter;
}

void remCol(float val) {
  colonies.remove(val);
  colSize--;
}

float getAverageStrength(float val) {
  float avg = 0;
  int div = count(val);
  for (Cell c : cells) {
    if (c.col == val && c.deathNote <= 0) {
      avg += c.strength;
    }
  }
  if (div > 0) {
    return round(avg/div*10)/10f;
  }
  return 0;
}

void rem(int maxSize) {
  if (cells.size() > maxSize) {
    for (int i = 0; i < cells.size()-maxSize; i++) {
      cells.remove(0);
    }
  }
}


void keyPressed() {
  if (state.getGameState() == GameState.SEED) {
    if ((keyCode == 173 || keyCode == 45 || keyCode == 109) && seedDisp.length() >= 1) {
      if (seedDisp.charAt(0) == '-') {
        seedDisp = seedDisp.substring(1);
      } else {
        seedDisp = '-'+seedDisp;
      }
    }

    if (keyCode == 8) {
      if (seedDisp.length() > 0) {
        seedDisp = seedDisp.substring(0, seedDisp.length()-1);
      }
    }

    if (keyCode == 49 || keyCode == 97) {
      seedDisp += '1';
    }
    if (keyCode == 50 || keyCode == 98) {
      seedDisp += '2';
    }
    if (keyCode == 51 || keyCode == 99) {
      seedDisp += '3';
    }
    if (keyCode == 52 || keyCode == 100) {
      seedDisp += '4';
    }
    if (keyCode == 53 || keyCode == 101) {
      seedDisp += '5';
    }
    if (keyCode == 54 || keyCode == 102) {
      seedDisp += '6';
    }
    if (keyCode == 55 || keyCode == 103) {
      seedDisp += '7';
    }
    if (keyCode == 56 || keyCode == 104) {
      seedDisp += '8';
    }
    if (keyCode == 57 || keyCode == 105) {
      seedDisp += '9';
    }

    if ((keyCode == 48 || keyCode == 96) && seedDisp.length() > 0) {
      seedDisp += '0';
    }

    if (keyCode == 13 || keyCode == 10) {
      if (seedDisp.length() > 0) {
        if (seedDisp.length() == 1 && seedDisp.charAt(0) == '-') {
          seed = millis();
        } else {
          seed = Long.parseLong(seedDisp);
        }
      } else {
        seed = millis();
      }
      init(seed);
      state.setPrevGameState(4);
      state.setGameState(1);
      timeStart = millis();
    }
  } else {
    if (keyCode == 32) {
      if (state.getGameState() == GameState.GAME) {
        state.setGameState(GameState.PAUSE);
        noLoop();
      } else {
        state.setGameState(GameState.GAME);
        loop();
      }
    }
  }
}
