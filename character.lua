local Character = {}
Character.__index = Character

function Character.new(world, x, y)
    local character = setmetatable({
        width = 32,
        height = 32,
        x = x,
        y = y,
        speed = 100,
        scale = _G.SCALE,
        scaleX = _G.SCALE,
        scaleY = _G.SCALE,
        flippedX = false,
    flippedY = false
    }, Character)

    character.body = love.physics.newBody(world, x, y, "dynamic")
    character.shape = love.physics.newRectangleShape(character.width, character.height)
    character.fixture = love.physics.newFixture(character.body, character.shape)

    return character
end

function Character:draw()
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.scale, self.scale)
end

function Character:reset()
    self.body:setPosition(self.x, self.y)
    self.body:setLinearVelocity(0, 0)
    self.body:setAngularVelocity(0)
    self.body:setAngle(0)
    self.body:setLinearDamping(0)
    self.body:setAngularDamping(0)
    self.body:applyForce(0, 0)
    self.scaleX = self.scale
    self.scaleY = self.scale
    self.flippedX = false
    self.flippedY = false
end

function Character:flipX()
    self.flippedX = not self.flippedX
    self.scaleX = -self.scaleX
end

function Character:flipY()
    self.flippedY = not self.flippedY
    self.scaleY = -self.scaleY
end

return Character
