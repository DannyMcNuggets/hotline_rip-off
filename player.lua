-- player.lua 

Player = Object:extend()

function Player:new(map)
    self.image = love.graphics.newImage('images/player.png')
    self.alive_image = love.graphics.newImage('images/player.png')
    self.dead_image = love.graphics.newImage('images/player_dead.png')
    self.shooting_image = love.graphics.newImage('images/player_F.png')
    self.shooting_duration = 0.1 
    self.scale = 1
    self.width = self.image:getWidth() 
    self.height = self.image:getHeight() 
    self.speed = 6000
    
    self.angle = 0
    self.origin_x = self.image:getWidth() / 2 
    self.origin_y = self.image:getHeight() / 2

    self.can_shoot = true
    self.shoot_cooldown = 0.2 
    self.time_since_last_shot = 0

    self.alive = true

    self.x = map.layers["spawner"].objects[1].x 
    self.y = map.layers["spawner"].objects[1].y - self.height * self.scale 
    self.collider = world:newCircleCollider(self.x, self.y, self.width*self.scale/2.2)
    self.collider:setCollisionClass('player')
    self.collider:setObject(self)
end

function Player:update(dt)
    if self.alive then 
        self.shooting_duration = self.shooting_duration - dt
        if self.shooting_duration <= 0 then
            self.image = self.alive_image
        end
        self.time_since_last_shot = self.time_since_last_shot + dt 
        if self.time_since_last_shot >= self.shoot_cooldown then
            self.can_shoot = true
        end

        local mouse_x, mouse_y = cam:mousePosition()
        self.angle = math.atan2(mouse_y - player.y, mouse_x - player.x)

        local vector_x = 0  
        local vector_y = 0  

    	local is_key_down = love.keyboard.isDown
        if is_key_down("a") then
            vector_x = -1
        elseif is_key_down("d") then
            vector_x = 1
        end

        if is_key_down("w") then
            vector_y = -1
        elseif is_key_down("s") then
            vector_y = 1
        end

        self.collider:setLinearVelocity(self.speed * vector_x * dt, self.speed * vector_y * dt)
    else 
        self.collider:setLinearVelocity(0, 0) -- keep in place after death
    end

    if self.collider:enter('field') then
        -- print("player is spotted")
        local collision_data = self.collider:getEnterCollisionData('field')
        local enemy = collision_data.collider:getObject()  
        enemy:trigger()

    elseif self.collider:enter('hearing') then
        -- print("enemy can hear us!")
        local collision_data = self.collider:getEnterCollisionData('hearing')
        local enemy = collision_data.collider:getObject()
        enemy.hearing = true

    elseif self.collider:enter('passage') then
        gameFunctions.passagePassed()
    end
end

function Player:draw()
    self.x, self.y = self.collider:getPosition()
    love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.origin_x, self.origin_y)
end

function Player:mousepressed(x, y, button) -- firing a bullet
    if button == 1 and self.can_shoot then
        self.image = self.shooting_image
        self.shooting_duration = 0.1 
        local shot_sound = player_shot:clone()  -- create a new instance for each shot
        shot_sound:play()

        -- camera shake 
        local shake_duration = 0.08
        local shake_magnitude = 1,5
        cam:shake(shake_duration, shake_magnitude)

        local bullet_start_x = self.x 
        local bullet_start_y = self.y 
 
        table.insert(list_of_bullets, Bullet(bullet_start_x, bullet_start_y, self.angle, self))
        self.can_shoot = false
        self.time_since_last_shot = 0
    end
end

function Player:dead()
    --self.alive = false
    --self.collider:setLinearVelocity(0, 0)
    self.can_shoot = false
    self.image = self.dead_image
    self.angle = -self.angle -- reverse image of dead body
end



