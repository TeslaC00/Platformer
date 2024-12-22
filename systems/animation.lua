local Animation = {}
Animation.__index = Animation

AnimationState = {
    PLAYING = 1,
    PAUSE = 2
}

local function parseImageFilename(filename)
    -- can read frames count too from regex
    local animationName, frameWidth, frameHeight = filename:match("^([a-zA-Z0-9]+)_(%d+)x(%d+)_%d+%.png$")
    if animationName and frameWidth and frameHeight then
        return animationName, tonumber(frameWidth), tonumber(frameHeight)
    else
        print("[ERROR]: Cannot apply regex on the file: ", filename)
        return nil, nil, nil
    end
end

local function createFrames(image, frameWidth, frameHeight)
    local maxFrames = image:getWidth() / frameWidth
    local frames = {}
    for i = 1, maxFrames, 1 do
        table.insert(frames,
            love.graphics.newQuad(frameWidth * (i - 1), 0, frameWidth, frameHeight, image:getWidth(), image:getHeight()))
    end
    return frames
end

function Animation.new(imagePath, frameWidth, frameHeight, frameDuration)
    local framDur = frameDuration or _G.FRAME_DURATION
    local image = love.graphics.newImage(imagePath)
    return setmetatable({
        image = image,
        frames = createFrames(image, frameWidth, frameHeight),
        frameIndex = 1,
        timer = 0,
        status = AnimationState.PLAYING,
        frameDuration = framDur
    }, Animation)
end

function Animation.newAnimations(imageDir, frameDuration)
    local animations = {}

    local items = love.filesystem.getDirectoryItems(imageDir)
    for _, item in ipairs(items) do
        local filePath = imageDir .. "/" .. item
        local info = love.filesystem.getInfo(filePath)
        if info and info.type == "file" then
            local name, width, height = parseImageFilename(item)
            if name and width and height then
                animations[name] = Animation.new(filePath, width, height, frameDuration)
                -- table.insert(animations, Animation.new(filePath, width, height, frameDuration))
            end
        end
    end

    return animations
end

function Animation:update(dt)
    if self.status == AnimationState.PAUSE then return end

    self.timer = self.timer + dt
    if self.timer >= self.frameDuration then
        self.timer = self.timer - self.frameDuration
        self.frameIndex = self.frameIndex % #self.frames + 1
    end
end

function Animation:draw(x, y, angle, sx, sy, ox, oy)
    love.graphics.draw(self.image, self.frames[self.frameIndex], x, y, angle, sx, sy, ox, oy)
end

function Animation:pause()
    self.status = AnimationState.PAUSE
end

function Animation:resume()
    self.status = AnimationState.PLAYING
end

return Animation
