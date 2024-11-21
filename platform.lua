local StaticObject = require "static-object"

local Platform = setmetatable({}, { __index = StaticObject })
Platform.__index = Platform

function Platform:new(world, x, y)
    local platform = StaticObject.new(self, world, x, y, love.graphics.getWidth(), 50)
    setmetatable(platform, Platform)

    return platform
end

function Platform:draw()
    love.graphics.setColor(_COLORS.LIGHT_GREEN)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(_COLORS.WHITE)

    -- debugging
    if _G.DEBUGGING then
        love.graphics.setColor(_COLORS.BLUE)
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(_COLORS.WHITE)
    end
end

return Platform
