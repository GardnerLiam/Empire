# Empire
A genetic algorithm simulation made in processing.


# Info Section
To the left of the simulation box is an info section. The info section contains the total population amount (which caps at 1750), the current time and the seed. If you hover over an obstacle with your mouse, it will also display the amount of cells that obstacle has killed. The rectangles (which appear in and out of existence) dictate the colony information and are only displayed if a colony has a minimum of four cells. The information beside the coloured box representing the colony is formatted as "colonlySize : colonyStrength."

# Movement and update
Each cell has a designated colony depicted by the color.
Each cell has an array of floats that represent angles in a unit vector.
Upon update, every cell will shift its life index over by one, and move in the direction of the angle at its index
If a cell comes into contact with another cell from a different colony, the one with the higher strength value will kill the other


# Natural disasters
There is a small percent chance that the colony (group of cells) with the highest population will be hit by a plauge killing a random amount of the colony.
There is a small chance that every member of every colony will be pushed in some random direction. This is called dispersion. Dispersion will kill every cell who's life is over 60%
There are also black dots (called obstacles) which kill every cell that touches it.

# An edited video of a simulation can be found here
http://bit.ly/2XXWhGg

# NOTE: 
The video was sped up by a factor of four and the music taken from the youtube channel jamestolich and can be found in this link. https://www.youtube.com/watch?v=oaqhGrRG8qc
