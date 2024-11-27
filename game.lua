local Player = require "player"
local Enemy = require "enemy"
local Level = require "level"
local Camera = require "camera"

local Game = {}
Game.__index = Game

World = love.physics.newWorld(0, _G.PIXELS_PER_METER * 60, true)
Play = true

local player
local enemy
local level
local camera

local accumulator = 0
local fixedTimeStep = _G.FIXED_TIME_STEP

function Game:load()
    -- player entities and world
    player = Player.new(World, 300, 100)
    enemy = Enemy.new(World, 700, 250)
    level = Level.new(World)
    camera = Camera:new()
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
    camera:setPosition(player.body:getPosition())
end

function Game:draw()
    -- local ox = player.body:getX() - love.graphics.getWidth() * 0.5
    -- local oy = player.body:getY() - love.graphics.getHeight() * 0.5
    camera:apply()
    level:draw()
    player:draw()
    enemy:draw()

    camera:remove()
end

function Game:keypressed(key)
    player:keypressed(key)
end

function Game:playPause()
    Play = not Play
end

function Game:reset()
    player:reset()
    enemy:reset()
end

return Game
