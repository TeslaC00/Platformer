local Player = require "player"
local Enemy = require "enemy"
local Platform = require "platform"

local Game = {}
Game.__index = Game

World = love.physics.newWorld(0, _G.PIXELS_PER_METER * 30, true)
Play = true

local player
local enemy
local platform
local wall = {}

local accumulator = 0
local fixedTimeStep = _G.FIXED_TIME_STEP

function Game:load()
    -- player entities and world
    player = Player:new(World, 300, 250)
    enemy = Enemy:new(World, 500, 250)

    platform = Platform:new(World, 0, 400)

    -- wall.x, wall.y = 0, 400
    -- wall.width, wall.height = love.graphics.getWidth(), 50
    -- wall.body = love.physics.newBody(World, wall.x, wall.y, "static")
    -- wall.shape = love.physics.newRectangleShape(wall.width / 2, wall.height / 2,
    -- wall.width, wall.height)
    -- wall.fixture = love.physics.newFixture(wall.body, wall.shape)
end

function Game:update(dt)
    Play = love.window.hasFocus() and Play
    if not Play then return end

    -- clamp delta time to avoid large updates
    if dt > 0.1 then dt = 0.1 end
    accumulator = accumulator + dt

    while accumulator >= fixedTimeStep do
        World:update(fixedTimeStep)
        player:update(fixedTimeStep)
        enemy:update(fixedTimeStep)

        accumulator = accumulator - fixedTimeStep
    end
end

function Game:draw()
    player:draw()
    enemy:draw()
    platform:draw()
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.polygon("line", wall.body:getWorldPoints(wall.shape:getPoints()))
    -- love.graphics.setColor(1, 1, 1)
end

function Game:keypressed(key)
    player:keypressed(key)
end

function Game:playPause()
    Play = not Play
end

function Game:reset()
    player:reset(300, 250)
    enemy:reset(500, 250)
end

return Game
