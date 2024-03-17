-- game_functions.lua

local function transitionToMenu()
    main_music:pause()
    exit_to_menu:play()
    menu_music:play()
    game_state = "menu"
end

local function transitionToGame()
    menu_music:pause()
    main_music:play()
    game_state = "playing"
end

-- Define a function to restart the level
local function restartLevel()
    resetGame()
    car_door:play()
end

local function passagePassed()
    game_state = "game_over"
    main_music:pause()
    passage_passed:play()
end

local function gameOverPassagePassed()
    if not passage_passed:isPlaying() then -- play music after the sound effect
            gameover_music:play()
    end
end

-- Export the functions
return {
    transitionToGame = transitionToGame,
    gameOverPassagePassed = gameOverPassagePassed,
    transitionToMenu = transitionToMenu,
    restartLevel = restartLevel,
    passagePassed = passagePassed
}