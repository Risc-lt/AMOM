
# Changelog
All notable changes to this project are documented in this file.

#[GS] -- {2024.7.3}

  Added

- [feature 1] One enemy, One player character

- [feature 2] Attack in turn

- [feature 3] HP visualization

- [feature 4] Basic playground setup

#[MVP] -- {2024.7.12}

  Added

- [feature 1] Complete basic scene mechanism.

- [feature 2] Build screen partition for story scene UI

- [feature 3] Right side column to display basic infomation of characters and enemies

- [feature 4] Bottom column to display different operations for player to choose

- [feature 5] Game playground to show the position of characters

- [feature 6] Add careeers and denfence for different kinds of attaks for character

- [feature 7] Build different types of enemies to make unique demages

- [feature 8] Set up basic state machine for enemy to select its object to attack

- [feature 9] Attack can be influenced by the position it is in now

- [feature 10] Players can select diffent slots for characters in the beginning of the game

- [feature 11] Add more characters for player to control and calculate

- [feature 12] More than one enemy can be intergrated into one game

- [feature 13] Refactor the game mechanism to control characters in sequence

#[Alpha] -- {2024.7.19}

  Added

- [feature 1] Test basic scene mechanisms to make sure them working well as expected

- [feature 2] Intergrate basic story telling into the scenes

- [feature 3] The action value of the character is represented by a random integer from 1 to the agile attribute

- [feature 4] The higher the action value, the first action is taken

- [feature 5] Buff and debuff can affect the order of actions

- [feature 6] Display the action order of a fixed number of roles or display only the role that moves next

- [feature 7] Normal attacks, magics and special skills can be evaded

- [feature 8] Normal Attacks have damage float

- [feature 9] Normal attacks may be countered, and also may be hit critically
 
- [feature 10] Add more attributes of strength, physique, agility and spirit to the characte depneding on their sprite

- [feature 11] Calculate and add subtle atrributes like dodge rate, physical and magical hit ratio, counterattack rate and critical hit rate

- [feature 12] Show these values in the side bar on the screen

#[Beta] -- {2024.7.26} 

  Added

- [feature 1] Modify the game scene to expose some interfaces for initializing different levels

- [feature 2] Make the current game scene into prototypes

- [feature 3] Final check the logic of whole game process and fix all bugs

- [feature 4] Characters can choose to open their backpacks and use items when they are in action

- [feature 5] Items in backpacks can have special skills and probably save the game in critical moments

- [feature 6] Player can choose between normal attack, magic, defense, and special skills at each character's action

- [feature 7] Energy is used to cast special skills, and Mana is used to cast magic

- [feature 8] Introduce the water fire gas earth element mechanism, magic has a single element, and the character has a percentage damage resistance to different elements

- [feature 9] Add action selection decisions to enemy characters

- [feature 10] Energy and Mana are displayed in the character status bar along with hp

- [feature 11] Magic and special skills can put buff or debuff on the targets

- [feature 12] Add effects of buff and debuff like precision, disarray, accelerate and retard

- [feature 13] Show these buffs and debuffs under the characters

- [feature 14] Add basic background music for the battle scenes

- [feature 15] Two story scenes before and after the battle scene

- [feature 16] Short animation including moving characters, short dialogs and floating camera spot

  Fixed

- [bug 1] characters go to rest after counterattack

#[RC] -- {2024.8.2} 

  Added

- [feature 1] Complete machenisms in story scenes like moving camera and triggering plots.

- [feature 2] Add different dialogues and movements into the stories.

- [feature 3] Design the arguments and items for charaters in different levels.

- [feature 4] Design the special triggers in different levels.

- [feature 5] Add beginning scene to start the game and modify settings.

- [feature 6] Add home page to display and select different levels.

- [feature 7] Visual feedback of scrolling pictures between levels.

- [feature 8] Add background pictures for battle field, control field and right column.

- [feature 9] Add dynamic user interface feedback like zooming out when mouse is on.

- [feature 10] Complete machanisms of skill animations within the battles.

#[Final] -- {2024.8.6} 

  Added

- [feature 1] 
  Removed

- [feature 1] 
  Changed

- [feature 1] 
  Fixed

- [bug 1] 