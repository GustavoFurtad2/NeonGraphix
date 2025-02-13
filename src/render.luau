local Render = {}
Render.__index = Render

function Render.new(width, height)

    local self = {

        player,

        width = width,
        height = height,

        backgroundColor = Color3.new(0, 0, 0),

        componentsBuffer = {
            rectangles = {}
        },

        currentRectangleIndex = 0
    }

    return setmetatable(self, Render)
end

function Render:init(player)

    self.player = player
    
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Parent = self.player.PlayerGui

    self.backgroundFrame = Instance.new("Frame")
    self.backgroundFrame.BackgroundColor3 = self.backgroundColor
    self.backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    self.backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    self.backgroundFrame.Parent = self.screenGui
end

function Render:setResolution(width, height)

    self.width, self.height = width, height
end

function Render:getResolution()

    return self.width, self.height
end

function Render:getGui()

    return self.screenGui
end

function Render:drawRectangle(position, size, color)

    self.currentRectangleIndex += 1

    local rectangle

    if self.currentRectangleIndex > #self.componentsBuffer.rectangles then

        rectangle = Instance.new("Frame")
        table.insert(self.componentsBuffer.rectangles, rectangle)
    end

    rectangle = self.componentsBuffer.rectangles[self.currentRectangleIndex]
    rectangle.Parent = self.screenGui
    rectangle.Position = position
    rectangle.Size = size
    rectangle.Transparency = 1
    rectangle.BackgroundColor3 = color

    return rectangle
end

function Render:setBackgroundColor(color)

    self.backgroundColor = color
end

function Render:clear()

    wait()

    for index, component in next, self.componentsBuffer.rectangles do

        component.Transparency = 1
    end
end

function Render:flip()

    self.backgroundFrame.BackgroundColor3 = self.backgroundColor

    for index, component in next, self.componentsBuffer.rectangles do

        component.Transparency = 0
    end

    self.currentRectangleIndex = 0
end

return Render