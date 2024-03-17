local function loadSounds()
    -- Define sound sources
    exit_to_menu = love.audio.newSource('sounds/Pause.wav', "static") 
    car_door = love.audio.newSource('sounds/CarClose.wav', "static") 
    passage_passed = love.audio.newSource('sounds/LevelComplete.wav', "static")
    window_breaks = love.audio.newSource('sounds/Glass2.wav', "static")
    bullet_hits_wall = love.audio.newSource('sounds/Knock.wav', "static")
    bullet_hits_wall:setVolume(0.3)
    bullet_hit = love.audio.newSource('sounds/BonesBreak.wav', "static")
    player_shot = love.audio.newSource('sounds/Kalashnikov.wav', "static")
    enemy_shot = love.audio.newSource('sounds/9mm.wav', "static")
    enemy_shot:setVolume(0.5)
    
    main_music = love.audio.newSource('sounds/mainMusic.wav', "stream")
    main_music:setLooping(true)

    menu_music = love.audio.newSource('sounds/menuMusic.wav', "stream")
    menu_music:setLooping(true)

    gameover_music = love.audio.newSource('sounds/gameoverMusic.wav', "stream")
    gameover_music:setLooping(true)
end

return {
    loadSounds = loadSounds
}
