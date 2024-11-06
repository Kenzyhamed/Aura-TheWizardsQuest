## How to play

- Use L to go right
- Use J to go left
- Collect all the three gems and navigate to the door to advance to the next level (we currently have 4 levels)
- If you get stuck, use R to reset the level
- You can not jump hence once you miss a gem, you fail the level


## Things that we need to optimize 

These are some major things that we need to do to save us a lot of space and make the overall code maintainable.
The tasks labeled as major are causing us to run out of space, but we have a clear plan to optimize them to use only about 10 percent of the space we’re currently using. 
This code was created to refine our movement mechanics and recognize different types of platforms and characters. 
Our goal is to reach at least 20-25 levels, which we believe is easily achievable with our current progress and future plans.

- TODO: We have used CMP after LDA throughout the code. since LDA sets the condition - we don't need to use CMP after. this needs to be changed.
- TODO: We don't need 2 variables for the same address. we can change the code to use one. (we are using 2 varibales for the same color memory)
- TODO: Add variables for all our custom characters.
- TODO: CHARACTER_VAR = #$DF - Need to look into this and use this instead of repeating DF.
- TODO (MAJOR): The platforms arrays need to be optimized. Instead of sending in address for each platform block, we will send address for the first block and the next byte will
  contain how many blocks are required to be printed on the next locations. This would decrease the amount memory used currently.
- TODO (MAJOR): the platform printing code needs to be optimized. Right now we are getting each location and then printing the character, but in the optimized code
  our string will send the initial location and how many further characters to print. This would save a lot of bytes when loading level data
- TODO: If the door is being printed at the same location then we will need that address only for one level and not for all.
- TODO: For copying char data the last four lines seem to be repetitive for these. Make this a subroutine.
- TODO: some of the border code is repetitive. we can make this a subroutine. (feedback from A1)
- TODO: Playing the sound before the gem has been collected feels unnatural. We will need to refactor this code so the sound can be played after
- TODO (MAJOR): Load new level routine needs to be optimized. Right now we have separate methods for each level but in the future, we should find a way to 
  call these setup levels using an offset
