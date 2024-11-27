local Level = {}
Level.__index = Level

local function createTiles(image, tileWidth, tileHeight)
    local cols = image:getWidth() / tileWidth
    local rows = image:getHeight() / tileHeight
    local tiles = {}
    for row = 1, rows, 1 do
        for col = 1, cols, 1 do
            table.insert(tiles,
                love.graphics.newQuad(tileWidth * (col - 1), tileHeight * (row - 1),
                    tileWidth, tileHeight, image:getWidth(), image:getHeight()))
        end
    end
    return tiles
end

function Level.new(world)
    local baseLevel = require "assets.levels.base-level-v1"
    local image = love.graphics.newImage("assets/Terrain_16x16.png")
    local level = setmetatable({
        image = image,
        tiles = createTiles(image, baseLevel.tilewidth, baseLevel.tileheight),
        width = baseLevel.width,
        height = baseLevel.height,
        tileWidth = baseLevel.tilewidth,
        tileHeight = baseLevel.tileheight,
        data = baseLevel.layers[1].data,
        body = love.physics.newBody(world, 0, 0, "static"),
        fixtures = {}
    }, Level)

    local colliders = baseLevel.layers[2].objects
    for _, collider in ipairs(colliders) do
        local shape = love.physics.newRectangleShape(2 * collider.x + collider.width,
            2 * collider.y + collider.height, collider.width * 2, collider.height * 2)
        local fixture = love.physics.newFixture(level.body, shape)
        table.insert(level.fixtures, fixture)
    end

    return level
end

function Level:draw()
    local scale = _G.SCALE
    for index, value in ipairs(self.data) do
        if value > 0 then
            local x = (index - 1) % self.width
            local y = math.floor((index - 1) / self.width)
            love.graphics.draw(self.image, self.tiles[value], x * self.tileWidth * scale,
                y * self.tileHeight * scale, 0, scale, scale)
        end
    end

    --#region Debugging
    if _G.DEBUGGING then
        -- draw collider outline
        love.graphics.setColor(_COLORS.GREEN)
        for _, fixture in ipairs(self.fixtures) do
            local x1, y1, x2, y2 = fixture:getBoundingBox(1)
            love.graphics.rectangle("line", x1, y1, x2 - x1, y2 - y1)
        end

        -- reset color
        love.graphics.setColor(_COLORS.WHITE)
    end
    --#endregion Debugging
end

function Level:getWidth()
    return self.baseLevel.tilewidth * self.baseLevel.layers[1].width * _G.SCALE
end

function Level:getHeight()
    return self.baseLevel.tileheight * self.baseLevel.layers[1].height * _G.SCALE
end

return Level
