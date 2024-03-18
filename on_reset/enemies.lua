-- enemies.lua

Enemy = Object:extend()

function Enemy:new(i)
    self.image = love.graphics.newImage('images/enemy_swat.png')
	self.alive_image = love.graphics.newImage('images/enemy_swat.png')
    self.dead_image = love.graphics.newImage('images/enemy_swatD.png')
    self.shooting_image = love.graphics.newImage('images/enemy_swatF.png')
    self.shooting_duration = 0.1 
	self.x = game_map.layers["enemy_spawners"].objects[i].x 
    self.y = game_map.layers["enemy_spawners"].objects[i].y 
    self.width = self.image:getWidth() 
    self.height = self.image:getHeight() 
    self.scale = 1
    self.origin_x = self.image:getWidth() / 2
    self.origin_y = self.image:getHeight() / 2
    self.angle = 0

    -- basic collider and hitbox
    self.collider = world:newCircleCollider(self.x, self.y, self.width*self.scale/2.5)
    self.collider:setCollisionClass('enemy')
    self.collider:setObject(self)

    -- visual spotting
    self.collider_field = world:newCircleCollider(self.x, self.y, self.height*4.5)
    self.collider_field:setCollisionClass('field')
    self.collider_field:setObject(self)

    -- hearing 
    self.collider_hearing = world:newCircleCollider(self.x, self.y, self.height*10)
    self.collider_hearing:setCollisionClass('hearing')
    self.collider_hearing:setObject(self)

    self.triggered = false
    self.dead = false
    self.can_shoot = false -- simulates reaction
    self.shoot_cooldown = 0.7
    self.time_since_last_shot = 0
    self.hearing = false

    self.behavior_type = love.math.random(1, 2)
    --self.behavior_type = 2 -- keep this for testing, switch to 'self.behavior_type = love.math.random(1, 2)' when issue fixed
    if self.behavior_type == 1 then
        self.speed = 2000 
    elseif self.behavior_type == 2 then
        self.rotation_speed = 0.5 -- adjust rotation speed as needed
        self.angle_reached = true
    end

    self.vector_y = math.random(-1, 1)  
    self.vector_x = math.random(-1, 1)  
end


function Enemy:update(dt)

    -- update hearing and visual field 
    local field_x, field_y = self.collider:getPosition()
    self.collider_field:setPosition(field_x, field_y)
    self.collider_hearing:setPosition(field_x, field_y)

    -- movement behaviors if alive
    if self.dead == false then

        self.shooting_duration = self.shooting_duration - dt
        if self.shooting_duration <= 0 then
            self.image = self.alive_image
        end

        if self.collider:enter('player') then
            self.shoot_cooldown = 0.1 -- prevent player from comming to close by increasing firing speed and killing the player
        end

        if self.behavior_type == 1 then 
            -- behavior type 1: move around in circles
            self:moveInCircles(dt)
            self.collider:setLinearVelocity(self.speed * self.vector_x * dt, self.speed * self.vector_y * dt)
        elseif self.behavior_type == 2 and not self.triggered then
            -- behavior type 2: rotate in place
            self:rotateInPlace(dt)
        end

        -- shoot at player
        if self.triggered and player.alive then 
            self.time_since_last_shot = self.time_since_last_shot + dt 
            if self.time_since_last_shot >= self.shoot_cooldown then
                self.can_shoot = true
            end
            local player_x, player_y = player.collider:getPosition()
            self.angle = math.atan2(player_y - self.y, player_x - self.x)
            if self.can_shoot then
                self.image = self.shooting_image
                self.shooting_duration = 0.1 

                local shot_sound = enemy_shot:clone()
                shot_sound:play()
                local bullet_spawn_offset = (self.width/6 * self.scale) 
                local enemy_x, enemy_y = self.collider:getPosition()
                local bullet_start_x = enemy_x + math.cos(self.angle) * bullet_spawn_offset
                local bullet_start_y = enemy_y + math.sin(self.angle) * bullet_spawn_offset
                table.insert(list_of_bullets, Bullet(bullet_start_x, bullet_start_y, self.angle, self)) -- create bullet in direction of player
                self.can_shoot = false
                self.time_since_last_shot = 0
            end
        end

    else
        -- keep collider in one place if dead
        self.collider:setPosition(self.x, self.y) 
    end
end


function Enemy:draw()
    self.x, self.y = self.collider:getPosition() -- draw player 
    love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.origin_x, self.origin_y)
end


function Enemy:dying()
    self.collider:setLinearVelocity(0, 0)
    self.image = self.dead_image
    self.dead = true
    self.collider:setCollisionClass('enemy_dead') 
    self.angle = -self.angle
end


function Enemy:moveInCircles(dt)
    if self.collider:enter('wall') or self.collider:enter('low_furniture') or self.collider:enter('enemy') or self.collider:enter('window') then
       
        local new_vector_x, new_vector_y = nil

        if self.vector_x == 0 then
            new_vector_x = (math.random() > 0.5) and 1 or -1
        else
           new_vector_x = (math.random() > 0.5) and -self.vector_x or 0
        end
        if self.vector_y == 0 then
            new_vector_y = (math.random() > 0.5) and 1 or -1
        else
           new_vector_y = (math.random() > 0.5) and -self.vector_y or 0
        end
        if new_vector_y == 0 and new_vector_y == 00 then
            new_vector_x = -self.vector_x
            new_vector_y = -self.vector_y
        end
        self.vector_x = new_vector_x
        self.vector_y = new_vector_y

        self.angle = math.atan2(self.vector_y, self.vector_x)
    end
end


function Enemy:rotateInPlace(dt)
    if self.angle_reached then
        -- choose a new target angle in the range from 20 to 170 degrees
        self.target_angle = math.rad(love.math.random(20, 170))
        self.angle_reached = false
    end

    -- calculate the angle to the target
    local angle_difference = self.target_angle - self.angle

    -- determine the rotation direction (clockwise or counterclockwise)
    local rotation_direction = 1
    if angle_difference < 0 then
        rotation_direction = -1
    end

    -- rotate towards the target angle
    local rotation_amount = self.rotation_speed * dt * rotation_direction
    self.angle = self.angle + rotation_amount

    -- if the target angle is reached
    if math.abs(angle_difference) < math.rad(1) then
        self.angle_reached = true
    end
end


function Enemy:trigger()
    self.triggered = true
end

function Enemy.createEnemies(game_map)
    local list = {}
    for i, v in ipairs(game_map.layers["enemy_spawners"].objects) do
        table.insert(list, Enemy(i))
    end
    return list
end

function Enemy.updateEnemies(list_of_enemies, dt)
    for i,v in ipairs(list_of_enemies) do -- update enemies
        v:update(dt)
    end
end

function Enemy.triggerEnemies(list_of_enemies)
    for i, enemy in ipairs(list_of_enemies) do
        enemy.triggered = enemy.hearing and true
    end
end

function Enemy.drawEnemies(list_of_enemies)
    for i,v in ipairs(list_of_enemies) do
        v:draw()
    end
end

return Enemy
