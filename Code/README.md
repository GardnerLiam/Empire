# Code
The code is segmented into four files:
  1. Empire: The main file
  2. Cell: A file containing the cell class
  3. GameState: A file containing a game state class (which could honestly just be one integer)
  4. Obstacle: A file containing the obstacle class.
  

# Empire
The Empire file is what you'd expect from a main file. It contains the setup and draw methods along with all global variables.

# Empire - Draw
The draw function is separated into multiple sub functions for drawing and running the simulation. These functions are separated to minimize the code in the draw function itself.

# Cell - Variables
The cell contains the following variables:
  1. x: x coordinate
  2. y: y coordinate
  3. life: an integer representing how long its lived and whether or not it should die (also used as the movement array index)
  4. movement: an array of floats representing the angle of a vector of magnitude 1, these are used to determine in what direction a the cell moves in at any given time
  5. strength: the strength value is used when two cells of varying colonies interact with each other. The cell with the higher strength will kill the other. Strength has a minimum value of 0.1.
  6. col: this is the float representing the colony (and its hue)
  7. birthPercent: if a cell's life is over half its lifespan, it has a chance of producing a child. that chance is dictated by this variable.
  8. isDead: if a cell dies, it can be set with this variable, the draw function will purge all the cells with isDead=true
  9. plagued: if a cell is hit by a plague or touches an obstacle, this variable is turned on. if plagued=true, the cell will turn black.
  10. deathNote: this is an integer that is continuously increased if plagued=true. if this variable is less than a certain amount. it will be drawn but cannot move. Once it passes said amount, it will be marked dead.
  11. dispersionTime: this is a version of the deathNote variable meant for dispersion.
  
# Cell - Functions
The move function takes in the arraylist of cells, this is only used to check for cell interactions. Otherwise, if the plague is not in effect, it will move in the direction given from the unit vector of the specific angle from the movement array at the life index. x and y are adjusted and then dispersion is checked. if dispersionTime is greater than zero (which means its activated) the positions are shifted several times by a dispersionStrength variable in the Empire file. If the positions of the cell exceed the window boundary, it will be sent to the opposite side. (e.g. if x > max_width : x = min_width). If the cell's life is greater than its lifespan or it has interacted with a cell having a greater strength, isDead is set to true. If the cell's life is over half its lifespan, there's a chance that it will call the birth method and a new cell will be added to the array.

The toString method is a way of visualizing the cell in the form of a string.

checkRadius is a function that takes two positions and checks whether or not they fall within a certain radius. That radius is a variable in the Empire function and can be altered. this way, if two colonies move towawrds each other and interact, the cells don't have to be exactly touching for the interaction to take place.

the birth function is the function that dictates how the mutations work. It first creates a copy of the cell. There is a really small chance that the colony will change. After that there's a 10% chance that, for each index of the movement array, the angle will change. There's a 10% chance that strength will either increase or drop by 0.1. BirthPercent also has a 10% chance to either increase or drop by 0.025.

# GameState
This is a relatively small class. It contains final variables for the states for the draw function. It also holds currentState and previousState integer variables and methods to set, get, and switch between states.

# Obstacle
The obstacle contains a position (x and y variables) and a radius which are all initialized at random. It also has a killCount variable to see how many cells its killed. It has a getKillCount method, a draw method and a collision method which checks if a cell has collided with the obstacle. If a cell does collide with the obstacle (and that cell is not plagued) the kill count will go up and the cell's plagued variable will be set to true.
