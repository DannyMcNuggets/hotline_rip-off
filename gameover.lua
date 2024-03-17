-- gameover.lua

local Gameover = {
	selected_option = 1,
	options = {"Restart", "Quit"}
}

function Gameover.draw()
	-- love.graphics.printf("Congrats, you passed the game", 0, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "center")
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("congrats", 400, 400)

	for i, option in ipairs(Gameover.options) do
        local y = (love.graphics.getHeight()/2 + love.graphics.getHeight()/5) + i * 50
        local color = {1, 1, 1}  -- default color is white

        if i == Gameover.selected_option then
            local shakeOffset = math.sin(love.timer.getTime() * 10) * 5  -- calculate shake effect
            y = y + shakeOffset

            local color_value = math.sin(love.timer.getTime() * 2) * 0.5 + 0.5  -- calculate color transition
            color = {1, color_value, color_value}
        end
        love.graphics.setColor(unpack(color))
        love.graphics.setFont(menu_font)
        love.graphics.printf(option, 0, y, love.graphics.getWidth(), "center")
    end
end

function Gameover.keypressed(key)
	if key == "up" then
		Gameover.selected_option = Gameover.selected_option - 1
		if Gameover.selected_option < 1 then
	    	Gameover.selected_option = #Gameover.options
	    end
	elseif key == "down" then
		Gameover.selected_option = Gameover.selected_option + 1
		if Gameover.selected_option > #Gameover.options then
			Gameover.selected_option = 1 
		end
	elseif key == "return" then
		if Gameover.selected_option == 1 then -- restart the game
			resetGame()
			game_state = "playing"
			gameover_music:pause()
			car_door:play()
		elseif Gameover.selected_option == 2 then -- exit the game
			love.event.quit()
		end
	end
end

return Gameover