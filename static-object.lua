local StaticObject = {}
StaticObject.__index = StaticObject

function StaticObject:new(world, x, y, width, height, texture)
    local object = setmetatable({
        x = x,
        y = y,
        width = width,
        height = height,
        scale = _G.SCALE,
        texture = texture or nil
    }, StaticObject)

    object.body = love.physics.newBody(world, x + width * 0.5, y + height * 0.5, "static")
    object.shape = love.physics.newRectangleShape(width, height)
    object.fixture = love.physics.newFixture(object.body, object.shape)

    return object
end

function StaticObject:draw()
    if self.texture then
        love.graphics.draw(self.texture, self.x, self.y, 0, self.scale, self.scale)
    end
end

return StaticObject
