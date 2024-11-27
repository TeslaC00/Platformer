local Character = require "character"
local Animation = require "systems.animation"

local Enemy = setmetatable({}, { __index = Character })
Enemy.__index = Enemy

local EnemyState = {
    HIT_1 = 1,
    HIT_2 = 2,
    IDLE = 3,
    RUN = 4,
    WALK = 5
}

function Enemy.new(world, x, y)
    local enemy = Character.new(world, x, y)
    setmetatable(enemy, Enemy)

    enemy.width = 36
    enemy.height = 30
    enemy.xOffset = 0
    enemy.yOffset = 0
    enemy.runSpeed = 200
    enemy.facingRight = false
    enemy.state = EnemyState.IDLE

    enemy.animations = Animation.newAnimations("assets/AngryPig")
    enemy.shape = love.physics.newRectangleShape(0, 6, 25 * enemy.scale, 23 * enemy.scale)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 2)

    return enemy
end

function Enemy:update(dt)
    local state = self.state
    local right = self.facingRight
    local dx, dy = 0, 0

    -- update enemy direction and speed
    if love.keyboard.isDown("left") then
        right = false
        dx = -self.speed
    elseif love.keyboard.isDown("right") then
        right = true
        dx = self.speed
    elseif love.keyboard.isDown("up") then
        dy = -self.speed
    elseif love.keyboard.isDown("down") then
        dy = self.speed
    end

    -- update enemy state on velocity
    if math.abs(dx) > 0 then
        state = EnemyState.WALK
    else
        state = EnemyState.IDLE
    end

    -- finalize transformations
    if self.facingRight ~= right then
        self.facingRight = right
        self:flipX()
    end

    -- update enemy state and velocity
    self.state = state
    self.body:setLinearVelocity(dx, dy)

    self.animations[self.state]:update(dt)
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
    self.facingRight = false
end

return Enemy
