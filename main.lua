require "globals"
local Game = require "game"
local ToggleButton = require "toggle-button"
local Button = require "button"

local debugButton, resetButton, playButton

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(_G.PIXELS_PER_METER)

    -- ui and buttons
    local smallFont = love.graphics.newFont(16)
    debugButton = ToggleButton.new(900, 20, 50, 20, "Debug", smallFont, false, _COLORS.WHITE,
        _COLORS.GREEN, _COLORS.RED, function(toggle) _G.DEBUGGING = toggle end)
    resetButton = Button.new(800, 20, 50, 20, "Reset", smallFont, _COLORS.WHITE, _COLORS.BLUE,
        function() Game:reset() end)
    playButton = ToggleButton.new(700, 20, 50, 20, "Play", smallFont, true, _COLORS.WHITE,
        _COLORS.GREEN, _COLORS.RED,
        function(toggle)
            local text = toggle and "Play" or "Pause"
            Game:playPause()
            playButton.text = text
        end)

    Game:load()
end

function love.update(dt)
    Game:update(dt)

    playButton:update(dt)
    debugButton:update(dt)
    resetButton:update(dt)
end

function love.draw()
    Game:draw()

    playButton:draw()
    resetButton:draw()
    debugButton:draw()

    if _G.DEBUGGING then
        local x, y = love.mouse.getPosition()
        local text = "X:" .. x .. " Y:" .. y
        love.graphics.print(text, x, y - 15)
    end
end

function love.keypressed(key)
    Game:keypressed(key)
end
