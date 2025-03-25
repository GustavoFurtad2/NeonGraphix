local Render2D = {}
Render2D.__index = Render2D

function Render2D.new(resolutionWidth, resolutionHeight, windowWidth, windowHeight)

    local self = {

        player,

        resolutionWidth = resolutionWidth,
        resolutionHeight = resolutionHeight,

        windowWidth = windowWidth,
        windowHeight = windowHeight,

        backgroundColor = Color3.new(0, 0, 0),

        componentsBuffer = {
            pixels = {},
            rectangles = {},
        },

        currentPixelIndex = 0,
        currentRectangleIndex = 0
    }

    return setmetatable(self, Render2D)
end

function Render2D:init(player)

    self.player = player
    
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Parent = self.player.PlayerGui

    self.backgroundFrame = Instance.new("Frame")
    self.backgroundFrame.BackgroundColor3 = self.backgroundColor
    self.backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    self.backgroundFrame.Size = UDim2.new(self.windowWidth, 0, self.windowHeight, 0)
    self.backgroundFrame.Parent = self.screenGui
end

function Render2D:setResolution(width, height)

    self.width, self.height = width, height
end

function Render2D:getResolution()

    return self.width, self.height
end

function Render2D:getGui()

    return self.screenGui
end

function Render2D:drawPixel(x, y, color)

    self.currentPixelIndex += 1

    local pixel

    if self.currentPixelIndex > #self.componentsBuffer.pixels then
        pixel = Instance.new("Frame")
        table.insert(self.componentsBuffer.pixels, pixel)
    end

    pixel = self.componentsBuffer.pixels[self.currentPixelIndex]
    pixel.Parent = self.screenGui

    local xScale = x / self.resolutionWidth
    local yScale = y / self.resolutionHeight
    local widthScale = self.windowWidth / self.resolutionWidth
    local heightScale = self.windowHeight / self.resolutionHeight

    pixel.Position = UDim2.new(xScale, 0, yScale, 0)
    pixel.Size = UDim2.new(widthScale, 0, heightScale, 0)
    pixel.Transparency = 1
    pixel.BackgroundColor3 = color

    return pixel
end

function Render2D:drawCircle(x, y, radius, fill, color)

    local xStart = math.floor(x - radius)
    local xEnd = math.floor(x + radius)
    local yStart = math.floor(y - radius)
    local yEnd = math.floor(y + radius)

    for i = xStart, xEnd do

        for j = yStart, yEnd do

            local dx = i - x
            local dy = j - y
            local distanceSquared = dx * dx + dy * dy

            if distanceSquared <= radius * radius then

                if fill then

                    self:drawPixel(math.floor(i), math.floor(j), color)
                else

                    if distanceSquared >= (radius - 1) * (radius - 1) then
                        self:drawPixel(math.floor(i), math.floor(j), color)
                    end
                end
            end
        end
    end
end

function Render2D:drawLine(x1, y1, x2, y2, thickness, color)

    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)

    local sx = (x1 < x2) and 1 or -1
    local sy = (y1 < y2) and 1 or -1

    local err = dx - dy

    local halfThickness = math.floor(thickness / 2)

    while true do

        for tx = -halfThickness, halfThickness do

            for ty = -halfThickness, halfThickness do
                
                local px, py = x1 + tx, y1 + ty

                if px >= 0 and px < self.width and py >= 0 and py < self.height then
                    self:drawPixel(px, py, color)
                end
            end
        end

        if x1 == x2 and y1 == y2 then 
            break
        end

        local e2 = 2 * err

        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end

        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

function Render2D:drawRectangle(x, y, width, height, color)
    
    self.currentRectangleIndex += 1

    local rectangle

    if self.currentRectangleIndex > #self.componentsBuffer.rectangles then
        rectangle = Instance.new("Frame")
        table.insert(self.componentsBuffer.rectangles, rectangle)
    end

    rectangle = self.componentsBuffer.rectangles[self.currentRectangleIndex]
    rectangle.Parent = self.screenGui
    
    local xScale = x / self.resolutionWidth
    local yScale = y / self.resolutionHeight
    local widthScale = width / self.resolutionWidth
    local heightScale = height / self.resolutionHeight

    rectangle.Position = UDim2.new(xScale * self.windowWidth, 0, yScale * self.windowHeight, 0)
    rectangle.Size = UDim2.new(widthScale * self.windowWidth, 0, heightScale * self.windowHeight, 0)
    rectangle.Transparency = 1
    rectangle.BackgroundColor3 = color

    return rectangle
end


function Render2D:setBackgroundColor(color)

    self.backgroundColor = color
end

function Render2D:clear()

    for index, component in next, self.componentsBuffer.rectangles do

        component.Transparency = 1
    end

    for index, component in next, self.componentsBuffer.pixels do

        component.Transparency = 1
    end
end

function Render2D:update()

    self.backgroundFrame.BackgroundColor3 = self.backgroundColor

    for index, component in next, self.componentsBuffer.rectangles do

        component.Transparency = 0
    end

    for index, component in next, self.componentsBuffer.pixels do

        component.Transparency = 0
    end

    self.currentPixelIndex = 0
    self.currentRectangleIndex = 0

    wait()
end

return Render2D