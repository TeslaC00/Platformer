local Button = require "ui.button"
local Game = require "systems.game"

local Menu = {}
Menu.__index = Menu

local buttons = {}

local smallFont = love.graphics.newFont(16)
local resetButton, debugButton, playButton

local resetButtonOpts = {
    callback = function()
        Game:reset()
    end,
    label = "Reset",
    font = smallFont,
    bgColor = _COLORS.BLUE,
    labelColor = _COLORS.WHITE,
}
local debugButtonOpts = {
    callback = function(button)
        _G.DEBUGGING = button.toggled
    end,
    label = "Debug",
    font = smallFont,
    bgColor = _COLORS.BLACK,
    labelColor = _COLORS.WHITE,

    onColor = _COLORS.DARK_GREEN,
    offColor = _COLORS.RED,
    onLabel = "Debug",
    offLabel = "Debug",
    isToggle = true
}
local playButtonOpts = {
    toggled = true,
    callback = function(button)
        if button.toggled then
            Game:play()
        else
            Game:pause()
        end
    end,
    label = "Play",
    font = smallFont,
    bgColor = _COLORS.BLACK,
    labelColor = _COLORS.WHITE,

    onColor = _COLORS.DARK_GREEN,
    offColor = _COLORS.RED,
    onLabel = "Play",
    offLabel = "Pause",
    isToggle = true
}

function Menu:load()
    -- ui and buttons
    resetButton = Button.new(800, 20, 50, 20, resetButtonOpts)
    debugButton = Button.new(900, 20, 50, 20, debugButtonOpts)
    playButton = Button.new(700, 20, 50, 20, playButtonOpts)

    table.insert(buttons, resetButton)
    table.insert(buttons, debugButton)
    table.insert(buttons, playButton)
end

function Menu:update(dt)
end

function Menu:mousepressed(x, y, button, _)
    if button == 1 then
        for _, btn in pairs(buttons) do
            if btn:hover(x, y) then
                btn:click()
            end
        end
    end
end

function Menu:draw()
    for _, btn in ipairs(buttons) do
        btn:draw()
    end
end

return Menu
