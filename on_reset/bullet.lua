-- bullet.lua

Bullet = Object:extend()

function Bullet:new(x, y, angle, shooter)
	self.image = love.graphics.newImage('images/bullet.png')
	self.x = x 
	self.y = y 
	self.width = self.image:getWidth() 
	self.height = self.image:getHeight()
	self.angle = angle 
	self.speed = 28000 -- below 80-100 A LOT of bullets start passing through walls.  
	self.origin_x = self.image:getWidth() / 2
	self.origin_y = self.image:getHeight() / 2
	self.scale = 2
	self.alive = true
	self.shooter = shooter -- needed to prevent bullets killing their own shooters

	--self.collider = world:newRectangleCollider(self.x, self.y, self.width*self.scale, self.height*self.scale)
	self.collider = world:newCircleCollider(self.x, self.y, self.width/2)
	self.collider:setCollisionClass('bullet')
	self.collider:setObject(self)

	self.collider:setPreSolve(function(col, other, contact) -- logic for destroying bullets before physics of collision resolved
        if other.collision_class == 'wall' then
            self.alive = false
            bullet_hits_wall:play()
            --print("self.alive set to false by PreSolve")
        end
   	end)

	self.exit_shooter = false
   	self.distance_traveled = 0 -- New distance counter
    self.max_distance = shooter.image:getWidth() * 27 -- THIS IS A MAGIC NUBMER FOR OFFSETING BULLET FROM CENTRE OF SHOOTER
end

function Bullet:update(dt)
    if not self.alive then -- destroy bullet right before the collision
    	self.collider:destroy()
    else
    	
    	-- update image and collider location
    	local vx = math.cos(self.angle) * self.speed * dt
		local vy = math.sin(self.angle) * self.speed * dt
		self.collider:setLinearVelocity(vx, vy)
		self.collider:setAngle(self.angle)

    	self.distance_traveled = self.distance_traveled + math.sqrt(vx^2 + vy^2)

	    -- Check if the bullet has traveled the required distance
	    if self.distance_traveled >= self.max_distance then
	        self.exit_shooter = true
	    end

		-- bullet killing player
	   	if self.collider:enter('player') then
	   		local collision_data = self.collider:getEnterCollisionData('player')
	   		local player = collision_data.collider:getObject()
	   		if player ~= self.shooter then
	   			player:dead() 
	   		end
	   		bullet_hit:play()

	   	-- bullet killing enemy
	   	elseif self.collider:enter('enemy') then
	   		local collision_data = self.collider:getEnterCollisionData('enemy')
	   		local enemy = collision_data.collider:getObject()
	   		if enemy ~= self.shooter then
	   			enemy:dying()
	   		end
	   		bullet_hit:play()

	    -- bullet breaking window
	    elseif self.collider:enter('window') then
		    local collision_data = self.collider:getEnterCollisionData('window')
		    for i, collider in ipairs(windowCollidersH) do
		        if collider == collision_data.collider then
		            table.remove(windowCollidersH, i)
			        collision_data.collider:destroy()
			        collision_data.collider:setCollisionClass('destroyed_window')
		            break
		        end
		    end

		    for i, collider in ipairs(windowCollidersV) do
		        if collider == collision_data.collider then
		            table.remove(windowCollidersV, i)
			        collision_data.collider:destroy()
			        collision_data.collider:setCollisionClass('destroyed_window')
		            break
		        end
		    end
		    window_breaks:play()
		end
	end
end


function Bullet:draw()
	if self.exit_shooter then
		local x, y = self.collider:getPosition()
    	love.graphics.draw(self.image, x, y, self.angle, self.scale, self.scale, self.origin_x, self.origin_y)
    end
end


function Bullet.updateBullets(list_of_bullets, dt)
	for i = #list_of_bullets, 1, -1 do
		local v = list_of_bullets[i]
		if not v.alive then
		table.remove(list_of_bullets, i)
		end
		v:update(dt)
	end
end


function Bullet.drawBullets(list_of_buleets)
	for i,v in ipairs(list_of_bullets) do
		v:draw()
	end
end


return Bullet