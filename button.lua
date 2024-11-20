local Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, font, textColor, bgColor, callback)
    return setmetatable({
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        font = font,
        timer = nil,
        textColor = textColor,
        bgColor = bgColor,
        callback = callback or nil
    }, Button)
end

function Button:update(dt)
    if self.timer then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = nil
        end
    else
        if self:hover() and love.mouse.isDown(1) and self.callback then
            self.callback()
            self.timer = 0.1
        end
    end
end

function Button:draw()
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    local x = self.x + (self.width - self.font:getWidth(self.text)) * 0.5
    local y = self.y + (self.height - self.font:getHeight()) * 0.5
    love.graphics.setColor(self.textColor)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, x, y)
    love.graphics.setColor(1, 1, 1)
end

function Button:hover()
    local x, y = love.mouse.getX(), love.mouse.getY()
    return x >= self.x and x <= self.x + self.width and
        y >= self.y and y <= self.y + self.height
end

return Button
