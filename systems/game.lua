local Player = require "entities.player"
local Enemy = require "entities.enemy"
local Level = require "systems.level"
local Camera = require "systems.camera"

Play = true

local Game = {}
Game.__index = Game

local accumulator = 0
local fixedTimeStep = _G.FIXED_TIME_STEP

function Game:load()
    -- player entities and world
    self.world = love.physics.newWorld(0, _G.PIXELS_PER_METER * 60, true)
    self.world:setCallbacks(
        function(a, b, contact) self:beginContact(a, b, contact) end,
        function(a, b, contact) self:endContact(a, b, contact) end,
        nil, nil)
    self.player = Player.new(self.world, 300, 200)
    self.enemy = Enemy.new(self.world, 700, 250)
    self.level = Level.new(self.world)
    self.camera = Camera.new(300, 200)
end

function Game:update(dt)
    Play = love.window.hasFocus() and Play
    if not Play then return end

    -- clamp delta time to avoid large updates
    if dt > 0.1 then dt = 0.1 end
    accumulator = accumulator + dt

    while accumulator >= fixedTimeStep do
        self.world:update(fixedTimeStep)
        self.player:update(fixedTimeStep)
        self.enemy:update(fixedTimeStep)

        for n in love.event.poll() do
            print("Event: ", n)
            if n == "player_on_ground" then
                love.event.clear()
            elseif n == "player_not_on_ground" then
                love.event.clear()
            end
        end

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

function Game:keypressed(key)
    self.player:keypressed(key)
end

function Game:playPause()
    Play = not Play
end

function Game:reset()
    self.player:reset()
    self.enemy:reset()
    self.camera:reset()
end

function Game:beginContact(a, b, contact)
    -- Gets called when two fixtures begin to overlap
    local fixtureA = a:getUserData()
    local fixtureB = b:getUserData()

    if _G.DEBUGGING then print("Collision detected between:", fixtureA, " and ", fixtureB) end

    if fixtureA == "player_ground_hitbox" or fixtureB == "player_ground_hitbox" then
        self.player.onGround = true
        if _G.DEBUGGING then print("Starting Collision fixtureA: ", fixtureA, " and fixtureB: ", fixtureB) end
    end
end

function Game:endContact(a, b, contact)
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
