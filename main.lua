-- main.lua handles the core game loop and state management.

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- initializes modules for the menu, gameplay, etc. 
	Object = require 'on_load/classic'
	Menu = require 'on_load/menu'
	Gameover = require 'on_load/gameover' 
	Restart = require 'on_load/restart'
	gameFunctions = require 'on_load/game_functions'

	--initial game_state
	game_state = 'menu'

	-- resets the game level (also prepares it for initial start)
	resetGame()

	-- set up sound
	sounds = require 'on_load/loadSounds'
	sounds.loadSounds()

	Background = require 'images/background' -- background changing colors in menu and game itself
end


function love.update(dt) 
	--fps = love.timer.getFPS() -- for testing
	Background.update(dt)

	-- menu logic is handled by love.draw and love.keypressed
	if game_state == 'menu' then
		menu_music:play()

	-- updates gameplay logic like the player, camera, bullets, and enemies.
	elseif game_state == 'playing' then
		player:update(dt) -- update player
		bulletClass.updateBullets(list_of_bullets, dt) -- update bullets and remove destroyed ones
	    Enemy.updateEnemies(list_of_enemies, dt) -- update enemies

    	-- camera 
    	cam:updateShake(dt) -- shake when player fired
		cam:lockPositionOffset(player, cam:figureDistance(40, 110), 30) -- figure distance for camera for offset based in shift press
		cam:rotateToGradually(0.12) -- map rotation based on player's location

	    world:update(dt)

	elseif game_state == 'game_over' then
		gameOverPassagePassed()
	end
end


function love.draw()
	love.mouse.setCursor(love.mouse.getSystemCursor('crosshair')) 
	love.graphics.setBackgroundColor(Background.getColor())
	if game_state == 'menu' then
		Menu.draw()
		love.mouse.setVisible(false)

	elseif game_state == "playing" then
		love.mouse.setVisible(true)
		cam:attach()
			game_map:drawLayer(game_map.layers['baseLayer'])
			game_map:drawLayer(game_map.layers['detailsLayer'])

			Bullet.drawBullets(list_of_buleets)
			Enemy.drawEnemies(list_of_enemies)

			player:draw()

			window.drawWindows(windowCollidersV, windowCollidersH)

			--world:draw() -- for testing
		cam:detach()

		-- small window suggesting restart if player died 
		if not player.alive then
			Restart.rectangularRestart(dt)
		end

		--local test_font = love.graphics.newFont('fonts/BebasNeue-Regular.ttf', 12) -- testing
		--love.graphics.setFont(test_font)
		--love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 100, 100) -- for testing

	elseif game_state == 'game_over' then
		love.mouse.setVisible(false)
		Gameover.draw()
	end
end


function love.keypressed(key) -- handles input based on the current game state.
    if game_state == 'playing' then
        if key == 'escape' then
            transitionToMenu()
        elseif key == 'r' and not player.alive then
            restartLevel()
        end
    elseif game_state == 'menu' then
        Menu.keypressed(key)
    elseif game_state == 'game_over' then
        Gameover.keypressed(key)
    end
end


function love.mousepressed(x, y, button)
    if game_state == 'playing' then
        player:mousepressed(x, y, button) -- logic for firing a bullet
		Enemy.triggerEnemies(list_of_enemies)
    end
end


function resetGame()
	-- create a new world
	local wf = require 'on_reset/windfield'
	world = wf.newWorld()

	-- set up collision classes (not in load since other levels might be added)
	local collisionClasses = require('on_reset/collision_classes')
    collisionClasses.setup(world) -- add classes to the world

	local sti = require 'on_reset/sti'
	game_map = sti('maps/tileMap.lua')

	-- create player at spawner location
	require 'on_reset/player'
	player = Player(game_map)

	local camera_setup = require "on_reset/camera_setup"
    cam = camera_setup.setupCamera()

	bulletClass = require 'on_reset/bullet'
	list_of_bullets = {} -- create empty list of bullets

	-- so these windows are very special and complicated, do not try to understand this :)
	window = require 'on_reset/window'
	window.loadImages()

	windowCollidersV = {} 
	windowCollidersH = {}
	
	-- giving collision classes to objects from the game_map
	local collision_setup = require "on_reset/collision_setup"
    collision_setup.setupCollisionClasses(world, game_map)

    -- creating enemies on spawners 
    local enemies = require 'on_reset/enemies'
    list_of_enemies = enemies.createEnemies(game_map)
end






