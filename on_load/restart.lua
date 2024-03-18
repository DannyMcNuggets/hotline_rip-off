restart_font = love.graphics.newFont('fonts/discoducksuperital.ttf', 40)

function rectangularRestart(dt)
    local restart_text = 'Press "R" to restart'
    local rect_x = love.graphics.getWidth()/8 
    local rect_y = love.graphics.getHeight() - love.graphics.getHeight()/5
    local rect_width = restart_font:getWidth(restart_text) + 20
    local rect_height = restart_font:getHeight(restart_text) + 20
    local color_transition_speed = 2  

    local color_value = (math.sin(love.timer.getTime() * color_transition_speed) * 0.25 + 0.75) 
    local text_color = {1, color_value, color_value}  -- pink to white transition

    -- draw black rectangle
    love.graphics.setColor(0, 0, 0, 0.9)  
    love.graphics.rectangle('fill', rect_x, rect_y, rect_width, rect_height)

    -- draw text with gradually changing color
    love.graphics.setColor(text_color)
    love.graphics.setFont(restart_font)
    
    love.graphics.print(restart_text, rect_x + 5, rect_y + 10)

    -- reset color to default!
    love.graphics.setColor(1, 1, 1)
end

return {
    rectangularRestart = rectangularRestart
}