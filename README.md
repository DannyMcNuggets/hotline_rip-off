# Hotline_rip-off

This game is the final project for the CS50 course. It's a simple top-down game with just one level. The game takes inspiration from Hotline Miami and includes basic features like moving around, shooting, NPCs behaviour, some objects that can be destroyed and game state handling.


## Gameplay Overview

The goal of the game is to navigate from the spawn point to the exit of the level while avoiding or taking down enemies. Enemies are triggered by the player's actions, such as shooting or moving close enough to be heard. One shot is lethal for both enemies and the player.

## Installation

Executable files are provided in the `executables` folder. There are two archives, one for x64 and one for x86 systems, each containing an `.exe` file along with all required DLL files. Additionally, a `.love` file is included in this folder which can be used to run the game through Love app on MacOS.

### Project Structure

- **on_load**: Contains files that handle overall game and different states (menu or gameplay).
- **on_reset**: Files in this directory handle gameplay mechanics and are used for resetting the level (enemies, bullets, player, obstacles, physics, camera behavior).
- **assets**: Contains textures, fonts, sounds, and map files.
- **conf**: Contains basic configuration information.

### Love2D Structure

The game follows the typical structure of a Love2D game:

- `love.load`: Initializes the game with modules and dependencies.
- `love.update`: Handles game logic and state transitions.
- `love.draw`: Renders graphics and visual elements to the screen.

The main file of the code is `main.lua`, which orchestrates the game's logic and structure.

### Game Setup

The `resetGame()` function in `main.lua` serves as the setup for each gaming level, providing default positioning and values. It is called on game load to start the level and also called on each restart (in case of player death or replay after game over).

## Libraries Used

- [hump.camera](https://hump.readthedocs.io/en/latest/camera.html): A camera library for Love2D.
- [windfield](https://github.com/a327ex/windfield): A physics module for Love2D.
- [Simple-Tiled-Implementation](https://github.com/karai17/Simple-Tiled-Implementation): A library for loading and rendering Tiled maps in Love2D.
