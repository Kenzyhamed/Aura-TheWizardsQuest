# Aura: The Wizards Quest

## Assignment 1
1. Changing Vic 20 background color
2. Border around the screen
3. Basic platform 
4. TitleScreen - displaying our groups names and some titlescreen art
5. PressKeyToStartGame - press the letter A to start the game
6. SoundEffects - the different sound effects for the characters interactions with platforms/portals
7. TitleScreenMusic - music to be played during the title screen
8. LeftJandRightL - oving the character left and right via J and L
9. Jump - ake character jump with spacebar
10. MovingPlatform - a platform that moves left and right infinitely
11. GemCollection - pressing keys to collect gems and increment a counter

### Compilation
#### Not using the emulator
1. Run `make` in the terminal

#### Using the emulator
1. ssh into the CPSC machine
2. Navigate to ~/www/
3. Run `mkdir AuraTheWizardsQuest-A1` to create a folder
4. Run `cd AuraTheWizardsQuest-A1`
5. Run `chmod 711` to update the permissions on the folder
6. Navigate back to the Assignment1 directiory
7. Run `make FOR_EMULATOR=1`

- You should be able to run any project via the emulator using (replace [your.username] and [ProjectName] with the correct values)
https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~[your.username]/AuraTheWizardsQuest-A1/[ProjectName].prg
