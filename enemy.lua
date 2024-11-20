Enemy = {}
Enemy.__index = Enemy

require "animation"

local EnemyState = {
    HIT_1 = 1,
    HIT_2 = 2,
    IDLE = 3,
    RUN = 4,
    WALK = 5
}

local imagePaths = {
    "assets/AngryPig/Hit 1 (36x30).png",
    "assets/AngryPig/Hit 2 (36x30).png",
    "assets/AngryPig/Idle (36x30).png",
    "assets/AngryPig/Run (36x30).png",
    "assets/AngryPig/Walk (36x30).png"
}

function Enemy:new(world, x, y)
    local enemy = setmetatable({
        width = 36,
        height = 30,
        xOffset = 0,
        yOffset = 0,
        speed = 100,
        runSpeed = 200,
        scale = 3,
        scaleX = 3,
        scaleY = 3,
        facingRight = false,
        state = EnemyState.IDLE,
    }, Enemy)
    enemy.animations = Animation:newAnimations(imagePaths, enemy.width, enemy.height)
    enemy.body = love.physics.newBody(world, x, y, "dynamic")
    enemy.shape = love.physics.newRectangleShape(0, 6, 25 * enemy.scale, 26 * enemy.scale)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
    enemy.fixture:setDensity(2)
    enemy.body:resetMassData()
    return enemy
end

function Enemy:load(x, y)
    self.state = EnemyState.IDLE
    self.facingRight = false
    self.scaleX = self.scale
    self.body:setPosition(x, y)
end

function Enemy:update(dt)
    local state = self.state
    local right = self.facingRight
    local dx, dy = 0, 0

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

    self.state = state
    self.body:setLinearVelocity(dx, dy)
    self.animations[self.state]:update(dt)
end

function Enemy:draw()
    -- print("Enemy Draw called")
    local x, y = self.body:getPosition()
    local ox, oy = self.width * 0.5, self.height * 0.5
    self.animations[self.state]:draw(x, y, 0, self.scaleX, self.scaleY, ox, oy)

    -- debugging
    if _G.DEBUGGING then
        love.graphics.points(x, y)
        local coord = "X: " .. x .. ",Y: " .. y
        love.graphics.print(coord, x, y)
        local x1, y1, x2, y2 = self.fixture:getBoundingBox(1)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("line", x1, y1, x2 - x1, y2 - y1)
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("line", x - (ox * 3), y - (oy * 3), 32 * 3, 32 * 3)
        love.graphics.setColor(1, 1, 1)
    end
end

function Enemy:flipX()
    if self.scaleX > 0 and not self.flippedX then
        self.flippedX = true
        self.scaleX = self.scaleX * -1
    elseif self.scaleX < 0 and self.flippedX then
        self.flippedX = false
        self.scaleX = self.scaleX * -1
    end
end

function Enemy:flipY()
    if self.scaleY > 0 and not self.flippedY then
        self.flippedY = true
        self.scaleY = self.scaleY * -1
    elseif self.scaleY < 0 and self.flippedY then
        self.flippedY = false
        self.scaleY = self.scaleY * -1
    end
end

-- return Enemy
