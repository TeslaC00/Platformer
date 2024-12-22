require "globals"
local Game = require "systems.game"
local Menu = require "systems.menu"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(_G.PIXELS_PER_METER)

    Menu:load()
    Game:load()
end

function love.update(dt)
    Game:update(dt)
    Menu:update(dt)
end

function love.draw()
    Game:draw()
    Menu:draw()

    if _G.DEBUGGING then
        local x, y = love.mouse.getPosition()
        local text = "X:" .. x .. " Y:" .. y
        love.graphics.print(text, x, y - 15)
    end
end

function love.keypressed(key)
    Game:keypressed(key)
end
