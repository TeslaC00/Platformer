Game = {}
Game.__index = Game

World = love.physics.newWorld(0, _G.PIXELS_PER_METER * 30, true)
Play = true

local player
local enemy
local wall = {}

local accumulator = 0
local fixedTimeStep = _G.FIXED_TIME_STEP

function Game:load()
    -- player entities and world
    player = Player:new(World, 300, 250)
    player:load(150, 150)
    print(player.body:getMass())
    print(player.body:getGravityScale())

    enemy = Enemy:new(World, 500, 250)
    enemy:load(500, 250)

    wall.x, wall.y = 0, 400
    wall.width, wall.height = love.graphics.getWidth(), 50
    wall.body = love.physics.newBody(World, wall.x, wall.y, "static")
    wall.shape = love.physics.newRectangleShape(wall.width / 2, wall.height / 2,
        wall.width, wall.height)
    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
end

function Game:update(dt)
    Play = love.window.hasFocus()
    if not Play then
        return
    end

    -- clamp delta time to avoid large updates
    if dt > 0.1 then dt = 0.1 end
    accumulator = accumulator + dt

    while accumulator >= fixedTimeStep do
        World:update(fixedTimeStep)
        player:update(fixedTimeStep)
        enemy:update(fixedTimeStep)

        accumulator = accumulator - fixedTimeStep
    end
end

function Game:draw()
    player:draw()
    enemy:draw()
    local x1, y1, x2, y2 = wall.fixture:getBoundingBox(1)
    love.graphics.setColor(1, 0, 0)
    love.graphics.polygon("line",wall.body:getWorldPoints(wall.shape:getPoints()))
    love.graphics.rectangle("line", x1, y1, x2 - x1, y2 - y1)
    love.graphics.setColor(1, 1, 1)
end

function Game:keypressed(key)
    player:keypressed(key)
end

function Game:reset()
    player:reset()
end
