require "globals"
local Game = require "game"
local ToggleButton = require "toggle-button"
local ResetButton = require "reset-button"

local debugButton, resetButton

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(_G.PIXELS_PER_METER)

    -- ui and buttons
    local smallFont = love.graphics.newFont(16)
    resetButton = ResetButton:new(600, 50, 50, 20, "Reset", smallFont)
    debugButton = ToggleButton:new(700, 50, 50, 20, "Debug", smallFont)

    Game:load()
end

function love.update(dt)
    Game:update(dt)

    debugButton:update(dt)
    resetButton:update(dt)
end

function love.draw()
    Game:draw()

    resetButton:draw()
    debugButton:draw()
end

function love.keypressed(key)
    Game:keypressed(key)
end
