local ResetButton = {}
ResetButton.__index = ResetButton

function ResetButton:new(x, y, width, height, text, font)
    return setmetatable({
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        font = font,
        timer = nil
    }, ResetButton)
end

function ResetButton:update(dt)
    if self.timer then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = nil
        end
    else
        if self:hover() and love.mouse.isDown(1) then
            love.load()
            self.timer = 0.1
        end
    end
end

function ResetButton:draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    local x = self.x + (self.width - self.font:getWidth(self.text)) * 0.5
    local y = self.y + (self.height - self.font:getHeight()) * 0.5
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, x, y)
end

function ResetButton:hover()
    local x, y = love.mouse.getX(), love.mouse.getY()
    return x >= self.x and x <= self.x + self.width and
        y >= self.y and y <= self.y + self.height
end

return ResetButton
