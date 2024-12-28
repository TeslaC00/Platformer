local Player = require "entities.player"
local Enemy = require "entities.enemy"
local Level = require "systems.level"
local Camera = require "systems.camera"

local Game = {}
Game.__index = Game

local accumulator = 0
local fixedTimeStep = _G.FIXED_TIME_STEP

function Game:load()
    -- player entities and world
    self.playing = true
    self.world = love.physics.newWorld(0, _G.PIXELS_PER_METER * 10, true)
    self.world:setCallbacks(
        function(a, b, contact) self:beginContact(a, b, contact) end,
        function(a, b, contact) self:endContact(a, b, contact) end,
        nil, nil)
    self.player = Player.new(self.world, 200, 100)
    self.enemy = Enemy.new(self.world, 700, 250)
    self.level = Level.new(self.world)
    self.camera = Camera.new(300, 200)
end

function Game:update(dt)
    -- Play = love.window.hasFocus() and Play
    if not self.playing then return end

    -- clamp delta time to avoid large updates
    if dt > 0.1 then dt = 0.1 end
    accumulator = accumulator + dt

    while accumulator >= fixedTimeStep do
        self.world:update(fixedTimeStep)
        self.player:update(fixedTimeStep)
        self.enemy:update(fixedTimeStep)

        accumulator = accumulator - fixedTimeStep
    end
    self.camera:setPosition(self.player.body:getPosition())
end

function Game:draw()
    self.camera:apply()

    self.level:draw()
    self.player:draw()
    self.enemy:draw()

    self.camera:remove()
end

function Game:play()
    self.playing = true
end

function Game:pause()
    self.playing = false
end

function Game:reset()
    self.player:reset()
    self.enemy:reset()
    self.camera:reset()
end

function Game:beginContact(a, b, _) -- contact parameter not used
    -- Gets called when two fixtures begin to overlap
    local fixtureA = a:getUserData()
    local fixtureB = b:getUserData()

    if _G.DEBUGGING then print("Collision detected between:", fixtureA, " and ", fixtureB) end

    if fixtureA == "player_ground_hitbox" or fixtureB == "player_ground_hitbox" then
        self.player.onGround = true
        if _G.DEBUGGING then print("Starting Collision fixtureA: ", fixtureA, " and fixtureB: ", fixtureB) end
    end
end

function Game:endContact(a, b, _)   -- contact parameter not used
    -- Gets called when two fixtures cease to overlap. This will also be called outside of a world update, when colliding objects are destroyed
    local fixtureA = a:getUserData()
    local fixtureB = b:getUserData()

    if _G.DEBUGGING then print("Ending Collision fixtureA: ", fixtureA, " and fixtureB: ", fixtureB) end

    if fixtureA == "player_ground_hitbox" or fixtureB == "player_ground_hitbox" then
        self.player.onGround = false
        if _G.DEBUGGING then print("Ending Collision fixtureA: ", fixtureA, " and fixtureB: ", fixtureB) end
    end
end

return Game
