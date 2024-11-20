require "player"
require "enemy"
local ToggleButton = require "toggle-button"
local ResetButton = require "reset-button"

local player
local enemy
local debugButton, resetButton

local pixelsPerMeter = 96

World = love.physics.newWorld(0, pixelsPerMeter * 30, true)
Play = true

local wall = {}

local accumulator = 0
local fixedTimeStep = 1 / 60

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(pixelsPerMeter)

    -- ui and buttons
    local smallFont = love.graphics.newFont(16)
    resetButton = ResetButton:new(600, 50, 50, 20, "Reset", smallFont)
    debugButton = ToggleButton:new(700, 50, 50, 20, "Debug", smallFont)

    -- player entities and world
    player = Player:new(World, 300, 250)
    player:load(150, 150)
    print(player.body:getMass())
    print(player.body:getGravityScale())

    enemy = Enemy:new(World, 500, 250)
    enemy:load(500, 250)

    wall.x, wall.y = 0, 400
    wall.width, wall.height = love.graphics.getWidth(), 50
    wall.body = love.physics.newBody(World, wall.x, wall.y, "static")
    wall.shape = love.physics.newRectangleShape(wall.width / 2, wall.height / 2,
        wall.width, wall.height)
    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
end

function love.update(dt)
    Play = love.window.hasFocus()
    if not Play then
        return
    end

    -- clamp delta time to avoid large updates
    if dt > 0.1 then dt = 0.1 end
    accumulator = accumulator + dt

    while accumulator >= fixedTimeStep do
        World:update(fixedTimeStep)
        player:update(fixedTimeStep)
        enemy:update(fixedTimeStep)
        debugButton:update(fixedTimeStep)
        resetButton:update(fixedTimeStep)

        accumulator = accumulator - fixedTimeStep
    end
end

function love.draw()
    player:draw()
    enemy:draw()
    local x1, y1, x2, y2 = wall.fixture:getBoundingBox(1)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", x1, y1, x2 - x1, y2 - y1)
    love.graphics.setColor(1, 1, 1)

    resetButton:draw()
    debugButton:draw()
end

function love.keypressed(key)
    player:keypressed(key)
end

function ResetGame()
    player:reset()
end
