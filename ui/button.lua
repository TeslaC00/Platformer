local Button = {}
Button.__index = Button

function Button.new(x, y, width, height, options)
    return setmetatable({
        x = x,
        y = y,
        width = width,
        height = height,
        toggled = options.toggled or false,
        callback = options.callback or nil,
        label = options.label or "Button",
        font = options.font or love.graphics.getFont(),
        bgColor = options.bgColor or _COLORS.BLACK,
        labelColor = options.labelColor or _COLORS.WHITE,

        -- toggle specific attributes
        onColor = options.onColor or _COLORS.DARK_GREEN,
        offColor = options.offColor or _COLORS.LIGHT_RED,
        onLabel = options.onLabel or "On",
        offLabel = options.offLabel or "Off",
        isToggle = options.isToggle or false,        -- is a toggle button
        lastClickTime = 0,                           -- Track time of the last click
        clickCooldown = options.clickCooldown or 0.3 -- Cooldown time in seconds
    }, Button)
end

function Button:draw()
    local bgColor = self.bgColor
    local label = self.label

    -- toggle specific colors
    if self.isToggle then
        if self.toggled then
            bgColor = self.onColor
            label = self.onLabel
        else
            bgColor = self.offColor
            label = self.offLabel
        end
    end

    -- Draw button backgronund
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw button label
    local x = self.x + (self.width - self.font:getWidth(label)) * 0.5
    local y = self.y + (self.height - self.font:getHeight()) * 0.5
    love.graphics.setColor(self.labelColor)
    love.graphics.setFont(self.font)
    love.graphics.print(label, math.floor(x), math.floor(y))

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

function Button:hover(x, y)
    return x >= self.x and x <= self.x + self.width and
        y >= self.y and y <= self.y + self.height
end

function Button:toggle()
    self.toggled = not self.toggled
end

function Button:click()
    local currentTime = love.timer.getTime()
    if currentTime - self.lastClickTime >= self.clickCooldown then
        -- Update the last click time
        self.lastClickTime = currentTime

        if self.isToggle then
            self:toggle()
        end

        if self.callback then
            self.callback(self)
        end
    end
end

return Button
