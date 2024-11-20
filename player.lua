Player = {}
Player.__index = Player

require "animation"

local PlayerState = {
    DOUBLE_JUMP = 1,
    FALL = 2,
    HIT = 3,
    IDLE = 4,
    JUMP = 5,
    RUN = 6,
    WALL_JUMP = 7
}

local imagePaths = {
    "assets/Virtual Guy/Double Jump (32x32).png",
    "assets/Virtual Guy/Fall (32x32).png",
    "assets/Virtual Guy/Hit (32x32).png",
    "assets/Virtual Guy/Idle (32x32).png",
    "assets/Virtual Guy/Jump (32x32).png",
    "assets/Virtual Guy/Run (32x32).png",
    "assets/Virtual Guy/Wall Jump (32x32).png"
}

function Player:new(world, x, y)
    -- shift shape by (width/2 + offsetX) * scale, (height/2 + offsetY) * scale
    local player = setmetatable({
        -- constants
        width = 32,
        height = 32,
        xOffset = 7,
        yOffset = 6,
        speed = 150,
        scale = 3,
        scaleX = 3,
        scaleY = 3,
        jump = 400,
        -- variables
        flippedX = false,
        flippedY = false,
        facingRight = true,
        state = PlayerState.IDLE,
    }, Player)
    player.animations = Animation:newAnimations(imagePaths, player.width, player.height)
    player.body = love.physics.newBody(world, x, y, "dynamic")
    player.body:setFixedRotation(true)
    player.shape = love.physics.newRectangleShape(0, 11, 17 * player.scale,
        24 * player.scale)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setDensity(5)
    player.body:resetMassData()
    return player
end

function Player:load(x, y)
    self.state = PlayerState.IDLE
    self.facingRight = true
    self.scaleX = self.scale
    self.body:setPosition(x, y)
end

function Player:update(dt)
    local state = self.state
    local right = self.facingRight
    local dx, dy = 0, 0
    local debug = _G.DEBUGGING

    if love.keyboard.isDown("a") then
        right = false
        dx = -self.speed
        if debug then print("a pressed") end
    elseif love.keyboard.isDown("d") then
        right = true
        dx = self.speed
        if debug then print("d pressed") end
    elseif love.keyboard.isDown("w") then
        dy = -self.speed
        if debug then print("w pressed") end
    elseif love.keyboard.isDown("s") then
        dy = self.speed
        if debug then print("s pressed") end
    end

    -- velocity code to change state
    local grounded = self.body:getY() >= 300

    if not grounded then
        if dy < 0 then
            state = PlayerState.JUMP
        elseif dy > 0 then
            state = PlayerState.FALL
        end
    else
        if math.abs(dx) > 0 then
            state = PlayerState.RUN
        else
            state = PlayerState.IDLE
        end
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

function Player:draw()
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

function Player:keypressed(key)
    local debug = _G.DEBUGGING
    if key == "space" then
        if debug then print("space pressed") end
        if self.state == PlayerState.IDLE or self.state == PlayerState.RUN then
            self.state = PlayerState.JUMP
        end
    end
end

function Player:flipX()
    if self.scaleX > 0 and not self.flippedX then
        self.flippedX = true
        self.scaleX = self.scaleX * -1
    elseif self.scaleX < 0 and self.flippedX then
        self.flippedX = false
        self.scaleX = self.scaleX * -1
    end
end

function Player:flipY()
    if self.scaleY > 0 and not self.flippedY then
        self.flippedY = true
        self.scaleY = self.scaleY * -1
    elseif self.scaleY < 0 and self.flippedY then
        self.flippedY = false
        self.scaleY = self.scaleY * -1
    end
end

-- return Player
