local camera = require "camera"

-- Function to set up the camera
local function setupCamera()
    local cam = camera(nil, nil, 3.5, nil, camera.smooth.damped(3)) -- set up camera
    cam.shake_timer = 0
    cam.shake_magnitude = 0
    return cam
end

return {
    setupCamera = setupCamera
}