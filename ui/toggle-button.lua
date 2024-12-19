local Button = require "ui.button"

local ToggleButton = setmetatable({}, { __index = Button })
ToggleButton.__index = ToggleButton

function ToggleButton.new(x, y, width, height, text, font, on, textColor, onColor, offColor, callback)
    local bgColor = onColor and on or offColor
    local toggleButton = Button.new(x, y, width, height, text, font, textColor, bgColor, callback)
    toggleButton.on = on or false
    toggleButton.onColor = onColor
    toggleButton.offColor = offColor
    return setmetatable(toggleButton, ToggleButton)
end

function ToggleButton:update(dt)
    if self.timer then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = nil
        end
    else
        if self:hover() and love.mouse.isDown(1) then
            self.on = not self.on
            if self.callback then self.callback(self.on) end
            self.timer = 0.1
        end
    end
end

function ToggleButton:draw()
    if self.on then
        self.bgColor = self.onColor
    else
        self.bgColor = self.offColor
    end
    Button.draw(self)
end

return ToggleButton
