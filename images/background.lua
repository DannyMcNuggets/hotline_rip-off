-- background.lua

local Background = {}

local colors = {
    {255, 179, 8},
    {98, 250, 118},
    {255, 3, 164},
    {67, 188, 183},
    {75, 130, 197}
}

local transition_time = 2 -- Time in seconds for each transition

local current_color_index = 1
local next_color_index = 2
local transition_progress = 0

function Background.update(dt)
    transition_progress = transition_progress + dt

    if transition_progress >= transition_time then
        transition_progress = 0

        current_color_index = next_color_index
        next_color_index = next_color_index + 1

        if next_color_index > #colors then
            next_color_index = 1
        end
    end
end

function Background.getColor()
    local current_color = colors[current_color_index]
    local next_color = colors[next_color_index]

    local t = transition_progress / transition_time
    local r = math.floor(current_color[1] + (next_color[1] - current_color[1]) * t)
    local g = math.floor(current_color[2] + (next_color[2] - current_color[2]) * t)
    local b = math.floor(current_color[3] + (next_color[3] - current_color[3]) * t)

    return { r / 255, g / 255, b / 255 }
end

return Background
