-- Function to set up collision classes
local function setupCollisionClasses(world, game_map, windowCollidersV, windowCollidersH)
    local static_layers = {"walls", "furniture", "boundaries", "low_furniture", "passage", "windows_v", "windows_h"}
    for i, layer_name in ipairs(static_layers) do
        for j, obj in ipairs(game_map.layers[layer_name].objects) do
            local collider = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collider:setType('static')
            if layer_name == "low_furniture" then
                collider:setCollisionClass('low_furniture')
            elseif layer_name == "passage" then
                collider:setCollisionClass('passage')
            elseif layer_name == "windows_v" or layer_name == "windows_h" then
                collider:setCollisionClass('window')
                if layer_name == "windows_v" then
                    table.insert(windowCollidersV, collider) 
                elseif layer_name == "windows_h" then
                    table.insert(windowCollidersH, collider)
                end
            else
                collider:setCollisionClass('wall')
            end
        end
    end 
end

return {
    setupCollisionClasses = setupCollisionClasses
}
