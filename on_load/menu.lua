-- menu.lua 

menu_font = love.graphics.newFont('fonts/discoduckchrome.ttf', 50)

local Menu = {
		selected_option = 1,
		options = {"Start game", "Quit"}
	}

	function Menu.draw()
		local optionHeight = menu_font:getHeight()
		local totalHeight = optionHeight * #Menu.options
	
		-- Start drawing from the lower third of the screen
		local startY = love.graphics.getHeight() * 4 / 5
	
		for i, option in ipairs(Menu.options) do
			local y = startY + (i - 1) * optionHeight
			local color = {1, 1, 1}  -- default color is white
	
			if i == Menu.selected_option then
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

function Menu.keypressed(key)
	if key == "up" then
		Menu.selected_option = Menu.selected_option - 1
		if Menu.selected_option < 1 then
            Menu.selected_option = #Menu.options
        end
   	elseif key == "down" then
   		Menu.selected_option = Menu.selected_option + 1
   		if Menu.selected_option > #Menu.options then
   			Menu.selected_option = 1 
   		end
   	elseif key == "return" then
   		if Menu.selected_option == 1 then
            transitionToGame()
   		elseif Menu.selected_option == 2 then
   			love.event.quit()
   		end
   	end
end

return Menu