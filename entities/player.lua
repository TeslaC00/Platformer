local Character = require "entities.character"
local Animation = require "systems.animation"

local Player = setmetatable({}, { __index = Character })
Player.__index = Player

--#region Player Constants
local JUMP = 300
local RUN_SPEED = 120
local SCALE = 2

local PlayerState = {
    DOUBLE_JUMP = "DoubleJump",
    FALL = "Fall",
    HIT = "Hit",
    IDLE = "Idle",
    JUMP = "Jump",
    RUN = "Run",
    WALL_JUMP = "WallJump"
}

local PlayerDir = {
    RIGHT = "right",
    LEFT = "left"
}
--#endregion

function Player.new(world, x, y)
    local player = Character.new(world, x, y)
    setmetatable(player, Player)

    player.xOffset = 7
    player.yOffset = 6
    player.onGround = false
    player.state = PlayerState.IDLE
    player.direction = PlayerDir.RIGHT

    -- physics
    player.dx = 0
    player.dy = 0
    player.world = world

    player.animations = Animation.newAnimations("assets/Virtual Guy")
    player.body:setFixedRotation(true)
    player.shape = love.physics.newRectangleShape(0, 9, 17 * player.scale, 18 * player.scale)
    player.groundHitboxShape = love.physics.newRectangleShape(0, 26, 16 * player.scale,
        2 * player.scale)
    player.fixture = love.physics.newFixture(player.body, player.shape, 5)
    player.fixture:setUserData("player_body_hitbox")
    player.groundHitboxFixture = love.physics.newFixture(player.body, player.groundHitboxShape, 5)
    player.groundHitboxFixture:setUserData("player_ground_hitbox")

    --#region Actions
    player.actions = {

        --#region Idle Action
        [PlayerState.IDLE] = function(dt)
            if not player.onGround then
                player.state = PlayerState.FALL
            elseif love.keyboard.wasPressed('space') and player.onGround then
                player.dy = -JUMP
                player.state = PlayerState.JUMP
            elseif love.keyboard.isDown("a") then
                player.dx = -RUN_SPEED
                player.state = PlayerState.RUN
                player.direction = PlayerDir.LEFT
            elseif love.keyboard.isDown("d") then
                player.dx = RUN_SPEED
                player.state = PlayerState.RUN
                player.direction = PlayerDir.RIGHT
            else
                player.dx = 0
            end
        end,
        --#endregion

        --#region Run Action
        [PlayerState.RUN] = function(dt)
            if not player.onGround then
                player.state = PlayerState.FALL
            elseif love.keyboard.wasPressed('space') and player.onGround then
                player.dy = -JUMP
                player.state = PlayerState.JUMP
            elseif love.keyboard.isDown("a") then
                player.dx = -RUN_SPEED
                player.direction = PlayerDir.LEFT
            elseif love.keyboard.isDown("d") then
                player.dx = RUN_SPEED
                player.direction = PlayerDir.RIGHT
            else
                player.dx = 0
                player.state = PlayerState.IDLE
            end
        end,
        --#endregion

        --#region Jump Action
        [PlayerState.JUMP] = function(dt)
            if love.keyboard.isDown("a") then
                player.dx = -RUN_SPEED
                player.direction = PlayerDir.LEFT
            elseif love.keyboard.isDown("d") then
                player.dx = RUN_SPEED
                player.direction = PlayerDir.RIGHT
            end

            if player.dy > 0 then
                player.state = PlayerState.FALL
            end
        end,
        --#endregion

        --#region Fall Action
        [PlayerState.FALL] = function(dt)
            if love.keyboard.isDown("a") then
                player.dx = -RUN_SPEED
                player.direction = PlayerDir.LEFT
            elseif love.keyboard.isDown("d") then
                player.dx = RUN_SPEED
                player.direction = PlayerDir.RIGHT
            end

            if player.dy >= 0 and player.onGround then
                player.state = PlayerState.IDLE
            end
        end
        --#endregion
    }
    --#endregion

    return player
end

function Player:update(dt)
    local dx, dy = self.body:getLinearVelocity()
    self.dx, self.dy = dx, dy

    self.actions[self.state](dt)

    if self.direction == PlayerDir.LEFT then
        self.scaleX = -SCALE
    else
        self.scaleX = SCALE
    end

    self.animations[self.state]:update(dt)

    self.body:setLinearVelocity(self.dx, self.dy)
end

function Player:draw()
    -- draw player texture with the current state and scales
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

        -- draw ground collider outline
        love.graphics.setColor(_COLORS.RED)
        love.graphics.polygon("line", self.body:getWorldPoints(self.groundColliderShape:getPoints()))

        -- reset color
        love.graphics.setColor(_COLORS.WHITE)
    end
    --#endregion Debugging
end

function Player:reset()
    -- reset player properties
    Character.reset(self)
    self.state = PlayerState.IDLE
    self.direction = PlayerDir.RIGHT
    self.onGround = false
end

return Player
