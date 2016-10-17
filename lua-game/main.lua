debug = true

-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

-- Image Storage
bulletImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated
bullets2 = {} -- array of current bullets being drawn and updated

--More timers
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
  
-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function
  
-- More storage
player2 = { x = 200, y = 10, speed = 150, img = nil }
enemyImg = nil 

player = { x = 200, y = 710, speed = 150, img = nil }
playerImg = nil


isAlive = true
isAlive2 = true
score = 0


-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end



function love.load(arg)
	player.img = love.graphics.newImage('assets/plane.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	player2.img = love.graphics.newImage('assets/enemy.png')
end

-- Updating
function love.update(dt)
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	
	-- Time out how far apart our shots can be.
	canShootTimer = canShootTimer - (1 * dt)
	
	if canShootTimer < 0 then
	  canShoot = true
	end
	
	if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
		-- Create some bullets
		newBullet = { x = player.x , y = player.y, img = bulletImg }
		secondNewBullet = { x = player.x + (player.img:getWidth()), y = player.y, img = bulletImg }
		table.insert(bullets, newBullet)
		table.insert(bullets, secondNewBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end
	
	if love.keyboard.isDown('ralt', 'lalt', 'alt') and canShoot then
		-- Create some bullets
		newBullet = { x = player2.x , y = player2.y +30, img = bulletImg }
		secondNewBullet = { x = player2.x + (player2.img:getWidth()), y = player2.y +30, img = bulletImg }
		table.insert(bullets2, newBullet)
		table.insert(bullets2, secondNewBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	if love.keyboard.isDown('left','a') then
		if player.x > 0 then -- binds us to the map
			player.x = (player.x - (player.speed*dt))
		end
		
		elseif love.keyboard.isDown('right','d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth())then
			player.x = (player.x + (player.speed*dt))
		end
	end
	 
	 if love.keyboard.isDown('1','z') then
		if player2.x > 0 then -- binds us to the map
			player2.x = (player2.x - (player2.speed*dt))
		end
		
		elseif love.keyboard.isDown('2','c') then
		if player2.x < (love.graphics.getWidth() - player2.img:getWidth())then
			player2.x = (player2.x + (player2.speed*dt))
		end
	end
	-- update the positions of bullets
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)

		if bullet.y < 0 then -- remove bullets when they pass off the screen
			table.remove(bullets, i)
		end
	end
		-- update the positions of bullets2
	for i, bullet in ipairs(bullets2) do
		bullet.y = bullet.y + (250 * dt)

		if bullet.y > (love.graphics:getHeight()) then -- remove bullets when they pass off the screen
			--table.remove(bullets2, i)
		end
	end
  
	for j, bullet in ipairs(bullets) do
		if CheckCollision(player2.x, player2.y, player2.img:getWidth(), 0, bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			isAlive2 = false
			print("player2 got shot")
		end
	end
			
	for j, bullet in ipairs(bullets2) do
		if CheckCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			isAlive = false
			print("player got shot")
		end
	end


	

	
	if not isAlive and love.keyboard.isDown('r') then
		-- remove all our bullets and enemies from screen
		bullets = {}
		bullets2 = {}
		--enemies = {}

		-- reset timers
		canShootTimer = canShootTimerMax
		--createEnemyTimer = createEnemyTimerMax

		-- move player back to default position
		player.x = 50
		player.y = 710
		
		player2.x = love.graphics.getWidth()-50
		player2.y = 10
		
		-- reset our game state
		score = 0
		isAlive = true
	end
	
	if not isAlive2 and love.keyboard.isDown('r') then
		-- remove all our bullets and enemies from screen
		bullets = {}
		bullets2 = {}
		--enemies = {}

		-- reset timers
		canShootTimer = canShootTimerMax
		--createEnemyTimer = createEnemyTimerMax

		-- move player back to default position
		player.x = 50
		player.y = 710

		player2.x = love.graphics.getWidth()-100
		player2.y = 10
		-- reset our game state
		score = 0
		isAlive2 = true
	end
end

function love.draw(dt)
	if isAlive then
		love.graphics.draw(player.img, player.x, player.y)
	else
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	end
	if isAlive2 then
		love.graphics.draw(player2.img, player2.x, player2.y)
	else
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	end
	for i, bullet in ipairs(bullets) do
	  love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
		for i, bullet in ipairs(bullets2) do
	  love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
	--for i, enemy in ipairs(enemies) do
		--love.graphics.draw(enemy.img, enemy.x, enemy.y)
--	end
end
