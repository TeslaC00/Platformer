local InputTextbox = {}
InputTextbox.__index = InputTextbox

function InputTextbox.new(x, y, width, height, opts)
    local self = setmetatable({}, InputTextbox)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.label = opts.label or "Text Box"
    self.text = opts.varValue or ""
    self.varKey = opts.varKey or nil
    self.varTable = opts.varTable or nil
    self.font = opts.font or love.graphics.newFont(16)
    self.bgColor = opts.bgColor or _COLORS.DARK_GREY
    self.textColor = opts.textColor or _COLORS.WHITE
    self.borderColor = opts.borderColor or _COLORS.BLACK
    self.activeBorderColor = opts.activeBorderColor or _COLORS.LIGHT_GREEN
    self.borderWidth = opts.borderWidth or 2
    self.isActive = false
    self.maxLength = opts.maxLength or 50
    return self
end

function InputTextbox:mousepressed(x, y, button)
    if button == 1 then
        -- Check if clicked inside the textbox
        self.isActive = x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height
    end
end

function InputTextbox:textinput(char)
    if self.isActive and #self.text < self.maxLength then
        self.text = self.text .. char
    end
end

function InputTextbox:keypressed(key)
    if self.isActive then
        if key == "backspace" then
            -- Remove the last character
            self.text = self.text:sub(1, -2)
        elseif key == "return" then
            self.varTable[self.varKey] = tonumber(self.text)
            self.isActive = false -- Deactivate on Enter
        end
    end
end

function InputTextbox:draw()
    -- Draw background
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw border
    if self.isActive then
        love.graphics.setColor(self.activeBorderColor)
    else
        love.graphics.setColor(self.borderColor)
    end
    love.graphics.setLineWidth(self.borderWidth)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Draw text
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.textColor)
    local text = string.format("%s: %s", self.label, self.text)
    local textX = self.x + 5
    local textY = self.y + self.height / 2 - self.font:getHeight() / 2
    local textLimit = self.width - 10
    love.graphics.printf(text, textX, textY, textLimit, "left")
end

return InputTextbox
