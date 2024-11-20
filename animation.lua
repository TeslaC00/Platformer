local Animation = {}
Animation.__index = Animation

AnimationState = {
    PLAYING = 1,
    PAUSE = 2
}

local function createFrames(image, frameWidth, frameHeight)
    local maxFrames = image:getWidth() / frameWidth
    local frames = {}
    for i = 1, maxFrames, 1 do
        table.insert(frames,
            love.graphics.newQuad(frameWidth * (i - 1), 0, frameWidth, frameHeight, image:getWidth(), image:getHeight()))
    end
    return frames
end

function Animation:new(imagePath, frameWidth, frameHeight, frameDuration)
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

function Animation:newAnimations(imagePaths, frameWidth, frameHeight, frameDuration)
    local animations = {}
    for _, value in ipairs(imagePaths) do
        table.insert(animations, self:new(value, frameWidth, frameHeight, frameDuration))
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
