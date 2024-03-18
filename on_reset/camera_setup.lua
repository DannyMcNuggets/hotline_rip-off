-- camera_setup.lua
local camera = require "on_reset/camera"

-- Function to calculate zoom factor based on aspect ratio
local function calculateZoomFactor(screenWidth, screenHeight)
    local aspectRatio = screenWidth / screenHeight
    local baseAspectRatio = 16 / 10

    if aspectRatio > baseAspectRatio then
        return aspectRatio / baseAspectRatio
    elseif aspectRatio < baseAspectRatio then
        return baseAspectRatio / aspectRatio
    else
        return 1 -- No adjustment needed
    end
end

-- Function to set up the camera
local function setupCamera()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local baseZoom = 3.5
    local zoomFactor = calculateZoomFactor(screenWidth, screenHeight)

    local cam = camera(nil, nil, baseZoom * zoomFactor, nil, camera.smooth.damped(3)) -- set up camera
    cam.shake_timer = 0
    cam.shake_magnitude = 0
    return cam
end

return {
    setupCamera = setupCamera
}
