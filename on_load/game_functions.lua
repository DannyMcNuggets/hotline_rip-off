-- game_functions.lua

function transitionToMenu()
    main_music:pause()
    exit_to_menu:play()
    menu_music:play()
    game_state = "menu"
end

function transitionToGame()
    menu_music:pause()
    main_music:play()
    game_state = "playing"
end

-- Define a function to restart the level
function restartLevel()
    resetGame()
    car_door:play()
end

function passagePassed()
    game_state = "game_over"
    main_music:pause()
    passage_passed:play()
end

function gameOverPassagePassed()
    if not passage_passed:isPlaying() then -- play music after the sound effect
            gameover_music:play()
    end
end


