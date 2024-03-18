-- main.lua handles the core game loop and state management.
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- initializes modules for the menu, gameplay, etc. 
	Object = require "classic"
	game_state = "menu"
	Menu = require "menu"
	Gameover = require 'gameover' 
	wf = require 'windfield'
	Restart = require 'restart'
	gameFunctions = require 'game_functions'
	bulletClass = require "bullet"
	-- resets the game level (also prepares it for initial start)
	resetGame()

	-- set up sound
	sounds = require 'load_and_setup/loadSounds'
	sounds.loadSounds()
end


function love.update(dt) -- Manages transitions between the menu, gameplay, and game over states.
	--fps = love.timer.getFPS() -- for testing
	Background.update(dt)

	-- menu logic is handles by love.draw and love.keypressed
	if game_state == "menu" then
		menu_music:play()

	-- updates gameplay logic like the player, camera, bullets, and enemies.
	elseif game_state == "playing" then
		bulletClass.updateBullets(list_of_bullets, dt) -- update bullets and remove destroyed ones

	    player:update(dt) -- update player

	    for i,v in ipairs(list_of_enemies) do -- update enemies
	        v:update(dt)
	    end

    	-- camera 
    	cam:updateShake(dt) -- shake when player fired
		
		-- cam:figureDistance сalculates camera position for default and "zoomed aiming"  
		-- function camera:figureDistance(baseDistance, extendedDistance) 

		-- cam:lockPositionOffset locks camera to player with offset determined by figureDistance() 
		--function camera:lockPositionOffset(player, distance, stiffness)
		cam:lockPositionOffset(player, cam:figureDistance(40, 110), 30)
	
		cam:rotateToGradually(0.12) -- map rotation based on player's location

	    world:update(dt)

	elseif game_state == "game_over" then
		gameFunctions.gameOverPassagePassed()
	end
end


function love.draw()
	love.mouse.setCursor(love.mouse.getSystemCursor("crosshair")) 
	love.graphics.setBackgroundColor(Background.getColor())
	if game_state == "menu" then
		Menu.draw()
		love.mouse.setVisible(false)

	elseif game_state == "playing" then
		love.mouse.setVisible(true)
		cam:attach()
			game_map:drawLayer(game_map.layers["baseLayer"])
			game_map:drawLayer(game_map.layers["detailsLayer"])

			for i,v in ipairs(list_of_bullets) do
				v:draw()
			end

			for i,v in ipairs(list_of_enemies) do
				v:draw()
			end

			player:draw()

			-- 
		    for i, collider in ipairs(windowCollidersV) do
			    local x = collider:getX() - windowV:getWidth() / 2
			    local y = collider:getY() - windowV:getHeight() / 2
			    love.graphics.draw(windowV, x, y)
			end

			for i, collider in ipairs(windowCollidersH) do
			    local x = collider:getX() - windowH:getWidth() / 2
			    local y = collider:getY() - windowH:getHeight() / 2
			    love.graphics.draw(windowH, x, y)
			end

			--world:draw() -- for testing
		cam:detach()

		-- small window suggesting restart if player died 
		if not player.alive then
			Restart.rectangularRestart(dt)
		end

		--local test_font = love.graphics.newFont('fonts/BebasNeue-Regular.ttf', 12) -- testing
		--love.graphics.setFont(test_font)
		--love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 100, 100) -- for testing

	elseif game_state == "game_over" then
		love.mouse.setVisible(false)
		Gameover.draw()
	end
end


function love.keypressed(key) -- handles input based on the current game state.
    if game_state == "playing" then
        if key == "escape" then
            gameFunctions.transitionToMenu()
        elseif key == "r" and not player.alive then
            gameFunctions.restartLevel()
        end
    elseif game_state == "menu" then
        Menu.keypressed(key)
    elseif game_state == "game_over" then
        Gameover.keypressed(key)
    end
end


function love.mousepressed(x, y, button)
    if game_state == "playing" then
        player:mousepressed(x, y, button) -- logic for firing a bullet
		Enemy.triggerEnemies(list_of_enemies)
    end
end


function resetGame()

	-- create a new world
	world = wf.newWorld()

	-- set up collision classes
	local collisionClasses = require("load_and_setup/collision_classes")
    collisionClasses.setup(world) -- add classes to the world

	local sti = require 'sti'
	game_map = sti('maps/tileMap.lua')

	require "player"
	player = Player(game_map)

	Background = require "background" -- background for menu and gameplay

	local camera_setup = require "load_and_setup/camera_setup"
    cam = camera_setup.setupCamera()

	list_of_bullets = {} -- create empty list of bullets

	-- so these windows are very special and complicated, do not try to understand this :)
	windowV = love.graphics.newImage('maps/sprGlassPanelV.png') 
	windowH = love.graphics.newImage('maps/sprGlassPanelH.png')

	windowCollidersV = {} 
	windowCollidersH = {}

	-- giving collision classes to objects from the game_map
	local collision_setup = require "load_and_setup/collision_setup"
    collision_setup.setupCollisionClasses(world, game_map, windowCollidersV, windowCollidersH)

    -- creating enemies on spawners 
    local enemies = require 'enemies'
    list_of_enemies = enemies.createEnemies(game_map)
end






