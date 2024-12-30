local Character = require("entities.character")
local Animation = require("systems.animation")

local Enemy = setmetatable({}, { __index = Character })
Enemy.__index = Enemy

--#region Enemy Constants
local constants = {
	WALK_SPEED = 100,
	RUN_SPEED = 200,
	SCALE = 2,
}

local EnemyState = {
	HIT_1 = "HIT1",
	HIT_2 = "HIT2",
	IDLE = "Idle",
	RUN = "Run",
	WALK = "Walk",
}

local EnemyDir = {
	RIGHT = "right",
	LEFT = "left",
}

local EnemyBehaviour = {
	LOOKING = 1,
}
--#endregion

function Enemy.new(world, x, y)
	local enemy = Character.new(world, x, y)
	setmetatable(enemy, Enemy)

	enemy.constants = constants

	enemy.dx = 0
	enemy.dy = 0
	enemy.width = 36
	enemy.height = 30
	enemy.xOffset = 0
	enemy.yOffset = 0
	enemy.walkRange = 50
	enemy.moveDistance = 50
	enemy.state = EnemyState.IDLE
	enemy.direction = EnemyDir.LEFT
	enemy.behaviour = EnemyBehaviour.LOOKING

	enemy.animations = Animation.newAnimations("assets/AngryPig")
	enemy.body:setFixedRotation(true)
	enemy.shape = love.physics.newRectangleShape(0, 6, 25 * enemy.scale, 23 * enemy.scale)
	enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 2)
	enemy.fixture:setUserData("enemy_body_hitbox")

	--#region Actions
	enemy.actions = {

		--#region Idle Action
		[EnemyState.IDLE] = function(dt)
			-- idle action no movement
			enemy.dx = 0
		end,
		--#endregion

		--#region Walk Action
		[EnemyState.WALK] = function(dt)
			if enemy.moveDistance > 0 then
				enemy.state = EnemyState.WALK
				if enemy.direction == EnemyDir.LEFT then
					enemy.dx = -enemy.constants.WALK_SPEED
				else
					enemy.dx = enemy.constants.WALK_SPEED
				end
			else
				enemy.dx = 0
				enemy.moveDistance = 0
				enemy.state = EnemyState.IDLE
			end
		end,
		--#endregion

		--#region Run Action
		[EnemyState.RUN] = function(dt)
			if enemy.moveDistance > 0 then
				enemy.state = EnemyState.RUN
				if enemy.direction == EnemyDir.LEFT then
					enemy.dx = -enemy.constants.RUN_SPEED
				else
					enemy.dx = enemy.constants.RUN_SPEED
				end
			else
				enemy.dx = 0
				enemy.moveDistance = 0
				enemy.state = EnemyState.IDLE
			end
		end,
		--#endregion
	}
	--#endregion

	--#region Behaviour
	enemy.behaviours = {

		--#region Looking Behaviour
		[EnemyBehaviour.LOOKING] = function(dt)
			-- behaviour flow
			-- Idle -> Walk -> Look for Player -> Idle
			local playerVisible, direction, distance = enemy.lookForPlayer()
			if playerVisible then
				enemy.state = EnemyState.RUN
				if direction < 0 then
					enemy.direction = EnemyDir.LEFT
				else
					enemy.direction = EnemyDir.RIGHT
				end
				enemy.moveDistance = distance
			else
				enemy.state = EnemyState.WALK
				if enemy.body:getX() <= enemy.x - enemy.walkRange then
					enemy.direction = EnemyDir.RIGHT
					enemy.moveDistance = enemy.walkRange * 2
				elseif enemy.body:getX() >= enemy.x + enemy.walkRange then
					enemy.direction = EnemyDir.LEFT
					enemy.moveDistance = enemy.walkRange * 2
				end
			end
		end
		--#endregion
	}

	--#endregion

	return enemy
end

function Enemy:lookForPlayer()
	return false
end

function Enemy:update(dt)
	self.dx, self.dy = self.body:getLinearVelocity()

	self.behaviours[self.behaviour](dt)
	self.actions[self.state](dt)

	if self.direction == EnemyDir.RIGHT then
		self.scaleX = -self.constants.SCALE
	else
		self.scaleX = self.constants.SCALE
	end

	self.animations[self.state]:update(dt)

	self.body:setLinearVelocity(self.dx, self.dy)
end

function Enemy:draw()
	-- draw enemy texture with the current state and scales
	local x, y = self.body:getPosition()
	local ox, oy = self.width * 0.5, self.height * 0.5
	self.animations[self.state]:draw(x, y, 0, self.scaleX, self.scaleY, ox, oy)

	--#region Debugging
	if _G.DEBUGGING then
		-- draw origin x and y
		love.graphics.points(x, y)
		local coord = "X: " .. x .. ",Y: " .. y
		love.graphics.print(coord, x, y)

		-- draw texture outline
		love.graphics.setColor(_COLORS.BLUE)
		love.graphics.rectangle("line", x - (ox * 3), y - (oy * 3), 32 * 3, 32 * 3)

		-- draw collider outline
		love.graphics.setColor(_COLORS.GREEN)
		love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))

		-- reset color
		love.graphics.setColor(_COLORS.WHITE)
	end
	--#endregion Debugging
end

function Enemy:reset()
	-- reset enemy properties
	Character.reset(self)
	self.state = EnemyState.IDLE
	self.direction = EnemyDir.LEFT
	self.behaviour = EnemyBehaviour.LOOKING
end

return Enemy
