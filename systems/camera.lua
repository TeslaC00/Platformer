local Camera = {}
Camera.__index = Camera

function Camera.new(x, y)
    return setmetatable({
        startX = x,
        startY = y,
        x = x,
        y = y,
        scaleX = 1,
        scaleY = 1,
        rotation = 0
    }, Camera)
end

-- TODO: This variable and function not used, remove it or use it
function Camera:setWidthLimit(limitW)
    self.lw = limitW
end

-- TODO: This variable and function not used, remove it or use it
function Camera:setHeightLimit(limitH)
    self.lh = limitH
end

function Camera:setPosition(x, y)
    self.x = x * self.scaleX
    self.y = y * self.scaleY
end

function Camera:apply()
    local x = -self.x + (love.graphics.getWidth() / 2)
    local y = -self.y + (love.graphics.getHeight() / 2)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.rotate(self.rotation)
end

function Camera:zoomIn()
    self.scaleX = self.scaleX + 0.1
    self.scaleY = self.scaleY + 0.1
end

function Camera:zoomOut()
    self.scaleX = self.scaleX - 0.1
    self.scaleY = self.scaleY - 0.1
end

function Camera:remove()
    love.graphics.pop()
end

function Camera:reset()
    self.x = self.startX
    self.y = self.startY
    self.scaleX = 1
    self.scaleY = 1
end

return Camera
