-- window.lua

local window = {}

function window.loadImages()
    windowV = love.graphics.newImage('maps/sprGlassPanelV.png') 
    windowH = love.graphics.newImage('maps/sprGlassPanelH.png')
end

function window.drawWindows(windowCollidersV, windowCollidersH)
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
end

return window
