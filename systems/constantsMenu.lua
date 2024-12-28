local InputTextBox = require "ui.inputTextBox"
local Game = require "systems.game"

local ConstantsMenu = {
    x = 0,
    y = 0,
    width = 300,
    lastBoxX = 0,
    lastBoxY = 0,
    padding = 10,
    boxWidth = 180,
    boxHeight = 20,
    entries = {},
    isVisible = false
}
ConstantsMenu.__index = ConstantsMenu

function ConstantsMenu:load()
    for key, value in pairs(Game.player.constants) do
        self:addEntry(key, Game.player.constants, key, value)
    end
end

function ConstantsMenu:addEntry(label, varTable, varKey, varValue)
    local textBoxOpts = {
        label = label,
        varTable = varTable,
        varKey = varKey,
        varValue = tostring(varValue)
    }
    local textBox = InputTextBox.new(self.lastBoxX + self.padding, self.lastBoxY + self.padding,
        self.boxWidth, self.boxHeight, textBoxOpts)

    self.lastBoxY = self.lastBoxY + self.padding + self.boxHeight

    table.insert(self.entries, textBox)
end

function ConstantsMenu:toggle()
    self.isVisible = not self.isVisible
end

function ConstantsMenu:mousepressed(x, y, button)
    if not self.isVisible then return end

    for _, entry in ipairs(self.entries) do
        entry:mousepressed(x, y, button)
    end
end

function ConstantsMenu:textinput(t)
    if not self.isVisible then return end

    for _, entry in ipairs(self.entries) do
        entry:textinput(t)
    end
end

function ConstantsMenu:keypressed(key)
    if not self.isVisible then return end

    for _, entry in ipairs(self.entries) do
        entry:keypressed(key)
    end
end

function ConstantsMenu:draw()
    if not self.isVisible then return end

    love.graphics.setColor(_COLORS.TRANSPARENT_BLACK)
    local height = #self.entries * (self.boxHeight + self.padding) + self.padding
    love.graphics.rectangle("fill", self.x, self.y, self.width, height)

    love.graphics.setColor(_COLORS.WHITE)
    for _, entry in ipairs(self.entries) do
        entry:draw()
    end
end

return ConstantsMenu
