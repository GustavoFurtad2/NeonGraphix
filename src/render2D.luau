local Render2D = {}
Render2D.__index = Render2D

function Render2D.new(resolution : Vector2, windowPosition : Vector2, windowSize : Vector2) : table

    local self = {

        player,

        resolution = resolution,
        windowPosition = windowPosition,
        windowSize = windowSize,

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

function Render2D:init(player : Instance)

    self.player = player
    
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Parent = self.player.PlayerGui

    self.backgroundFrame = Instance.new("Frame")
    self.backgroundFrame.BackgroundColor3 = self.backgroundColor
    self.backgroundFrame.Position = UDim2.new(self.windowPosition.X, 0, self.windowPosition.Y, 0)
    self.backgroundFrame.Size = UDim2.new(self.windowSize.X, 0, self.windowSize.Y, 0)
    self.backgroundFrame.Parent = self.screenGui
end

function Render2D:setResolution(resolution : Vector2)

    self.resolution = resolution
end

function Render2D:getResolution() : Vector2

    return self.resolution
end

function Render2D:getGui() : Instance

    return self.screenGui
end

function Render2D:drawPixel(position : Vector2, color : Color3) : Instance

    self.currentPixelIndex += 1

    local pixel

    if self.currentPixelIndex > #self.componentsBuffer.pixels then
        pixel = Instance.new("Frame")
        table.insert(self.componentsBuffer.pixels, pixel)
    end

    pixel = self.componentsBuffer.pixels[self.currentPixelIndex]
    pixel.Parent = self.screenGui

    local xScale = position.X / self.resolution.X
    local yScale = position.Y / self.resolution.Y
    local widthScale = self.windowSize.X / self.resolution.X
    local heightScale = self.windowSize.Y / self.resolution.Y

    pixel.Position = UDim2.new(xScale + self.windowPosition.X, 0, yScale + self.windowPosition.Y, 0)
    pixel.Size = UDim2.new(widthScale, 0, heightScale, 0)
    pixel.Transparency = 1
    pixel.BackgroundColor3 = color

    return pixel
end

function Render2D:drawCircle(position : Vector2, radius : number, fill : bool, color : Color)

    local xStart = math.floor(position.X - radius)
    local xEnd = math.floor(position.X + radius)
    local yStart = math.floor(position.Y - radius)
    local yEnd = math.floor(position.Y + radius)

    for i = xStart, xEnd do

        for j = yStart, yEnd do

            local dx = i - position.X
            local dy = j - position.Y
            local distanceSquared = dx * dx + dy * dy

            if distanceSquared <= radius * radius then

                if fill then

                    self:drawPixel(Vector2.new(math.floor(i) + self.windowPosition.X, math.floor(j) + self.windowPosition.Y), color)
                else

                    if distanceSquared >= (radius - 1) * (radius - 1) then
                        self:drawPixel(Vector2.new(math.floor(i) + self.windowPosition.X, math.floor(j) + self.windowPosition.Y), color)
                    end
                end
            end
        end
    end
end

function Render2D:drawLine(position1 : Vector2, position2 : Vector2, thickness : number, color : Color3)

    local dx = math.abs(position2.X - position1.X)
    local dy = math.abs(position2.Y - position1.Y)

    local sx = (position1.X < position2.X) and 1 or -1
    local sy = (position1.Y < position2.Y) and 1 or -1

    local err = dx - dy

    local halfThickness = math.floor(thickness / 2)

    while true do

        for tx = -halfThickness, halfThickness do

            for ty = -halfThickness, halfThickness do
                
                local px, py = position1.X + tx, position1.Y + ty

                if px >= 0 and px < self.resolution.X and py >= 0 and py < self.resolution.Y then
                    self:drawPixel(Vector2.new(px + self.windowPosition.X, py + self.windowPosition.Y), color)
                end
            end
        end

        if position1.X == position2.X and position1.Y == position2.Y then 
            break
        end

        local e2 = 2 * err

        if e2 > -dy then
            err = err - dy
            position1 += Vector2.new(sx, 0)
        end

        if e2 < dx then
            err = err + dx
            position1 += Vector2.new(0, sy)
        end
    end
end

local function interpolateX(p1 : Vector2, p2 : Vector2, y : number) : (number)
            
    if p1.Y == p2.Y then 
        return p1.X
    end

    return p1.X + (y - p1.Y) * (p2.X - p1.X) / (p2.Y - p1.Y)
end

function Render2D:drawTriangle(position1 : Vector2, position2 : Vector2, position3 : Vector2, thickness : number, fill : bool, color : Color3)

    if fill then

        local points = {position1, position2, position3}

        table.sort(points, function(a, b) return a.Y < b.Y end)

        local top, mid, bot = points[1], points[2], points[3]

        for y = math.floor(top.Y), math.floor(bot.Y) do

            local x1 = math.floor(interpolateX(top, bot, y))
            
            local x2

            if y < mid.Y then
                x2 = math.floor(interpolateX(top, mid, y))
            else
                x2 = math.floor(interpolateX(mid, bot, y))
            end

            if x1 > x2 then x1, x2 = x2, x1 end

            for x = x1, x2 do
                self:drawPixel(Vector2.new(x, y), color)
            end
        end
    end

    self:drawLine(Vector2.new(position1.X, position1.Y), Vector2.new(position2.X, position2.Y), thickness, color)
    self:drawLine(Vector2.new(position2.X, position2.Y), Vector2.new(position3.X, position3.Y), thickness, color)
    self:drawLine(Vector2.new(position3.X, position3.Y), Vector2.new(position1.X, position1.Y), thickness, color)
end

function Render2D:drawRectangle(position : Vector2, size : Vector2, color : Color3) : instance
    
    self.currentRectangleIndex += 1

    local rectangle

    if self.currentRectangleIndex > #self.componentsBuffer.rectangles then
        rectangle = Instance.new("Frame")
        table.insert(self.componentsBuffer.rectangles, rectangle)
    end

    rectangle = self.componentsBuffer.rectangles[self.currentRectangleIndex]
    rectangle.Parent = self.screenGui
    
    local xScale = position.X / self.resolution.X
    local yScale = position.Y / self.resolution.Y
    local widthScale = size.X / self.resolution.X
    local heightScale = size.Y / self.resolution.Y

    rectangle.Position = UDim2.new((xScale * self.windowSize.X) + self.windowPosition.X, 0, (yScale * self.windowSize.Y) + self.windowPosition.Y, 0)
    rectangle.Size = UDim2.new(widthScale * self.windowSize.X, 0, heightScale * self.windowSize.Y, 0)
    rectangle.Transparency = 1
    rectangle.BackgroundColor3 = color

    return rectangle
end

function Render2D:clear(color : Color3)

    self.backgroundColor = color

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