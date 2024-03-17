
local function transitionToMenu()
    main_music:pause()
    exit_to_menu:play()
    menu_music:play()
    game_state = "menu"
end

-- Define a function to restart the level
local function restartLevel()
    resetGame()
    car_door:play()
end

-- Export the functions
return {
    transitionToMenu = transitionToMenu,
    restartLevel = restartLevel
}
