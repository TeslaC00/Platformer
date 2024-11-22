local Player = require "player"
local Enemy = require "enemy"
local Level = require "level"

local Game = {}
Game.__index = Game

World = love.physics.newWorld(0, _G.PIXELS_PER_METER * 60, true)
Play = true

local player
local enemy
local level

local accumulator = 0
local fixedTimeStep = _G.FIXED_TIME_STEP

function Game:load()
    -- player entities and world
    player = Player:new(World, 300, 250)
    enemy = Enemy:new(World, 700, 250)

    level = Level:new(World)
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
    level:draw()
    player:draw()
    enemy:draw()
end

function Game:keypressed(key)
    player:keypressed(key)
end

function Game:playPause()
    Play = not Play
end

function Game:reset()
    player:reset(300, 250)
    enemy:reset(700, 250)
end

return Game
