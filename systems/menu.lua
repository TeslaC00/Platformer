local ToggleButton = require "ui.toggle-button"
local Button = require "ui.button"
local Game = require "systems.game"

local Menu = {}
Menu.__index = Menu

local debugButton, resetButton, playButton

function Menu:load()
    -- ui and buttons
    local smallFont = love.graphics.newFont(16)
    debugButton = ToggleButton.new(900, 20, 50, 20, "Debug", smallFont, false, _COLORS.WHITE,
        _COLORS.DARK_GREEN, _COLORS.RED, function(toggle) _G.DEBUGGING = toggle end)
    resetButton = Button.new(800, 20, 50, 20, "Reset", smallFont, _COLORS.WHITE, _COLORS.BLUE,
        function() Game:reset() end)
    playButton = ToggleButton.new(700, 20, 50, 20, "Play", smallFont, true, _COLORS.WHITE,
        _COLORS.DARK_GREEN, _COLORS.RED,
        function(toggle)
            local text = toggle and "Play" or "Pause"
            Game:playPause()
            playButton.text = text
        end)
end

function Menu:update(dt)
    playButton:update(dt)
    debugButton:update(dt)
    resetButton:update(dt)
end

function Menu:draw()
    playButton:draw()
    resetButton:draw()
    debugButton:draw()
end

return Menu
