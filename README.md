# Processing-Simulation
A genetic algorithm simulation made in processing.

# Movement and update
Each cell has a designated colony depicted by the color.
Each cell has an array of floats that represent angles in a unit vector.
Upon update, every cell will shift its life index over by one, and move in the direction of the angle at its index
If a cell comes into contact with another cell from a different colony, the one with the higher strength value will kill the other

# Natural disasters
There is a small percent chance that the colony (group of cells) with the highest population will be hit by a plauge killing a random amount of the colony.
There is a small chance that every member of every colony will be pushed in some random direction. This is called dispersion. Dispersion will kill every cell who's life is over 60%
There are also black dots (called obstacles) which kill every cell that touches it.
