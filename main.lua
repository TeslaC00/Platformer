require "globals"
local Game = require "systems.game"
local Menu = require "systems.menu"

-- global key-handling
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(_G.PIXELS_PER_METER)

    Menu:load()
    Game:load()
end

function love.mousepressed(x, y, button, isTouch)
    Menu:mousepressed(x, y, button, isTouch)
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if love.keyboard.keysReleased[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    Game:update(dt)
    Menu:update(dt)

    -- reset all keys pressed and released
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
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
    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end
