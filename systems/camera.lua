local Camera = {}
Camera.__index = Camera

function Camera.new()
    return setmetatable({
        x = 0,
        y = 0,
        scaleX = 1,
        scaleY = 1,
        rotation = 0
    }, Camera)
end

function Camera:setWidthLimit(limitW)
    self.lw = limitW
end

function Camera:setHeightLimit(limitH)
    self.lh = limitH
end

function Camera:setPosition(x, y)
    self.x = x
    self.y = y
end

function Camera:apply()
    local x = -self.x + (love.graphics.getWidth() / 2)
    local y = -self.y + (love.graphics.getHeight() / 2)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.rotate(self.rotation)
end

function Camera:remove()
    love.graphics.pop()
end

return Camera
