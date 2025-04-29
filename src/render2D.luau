local Render2D = {Renderers = {}}

function Render2D.createRenderer(resolution : Vector2, windowPosition : Vector2, windowSize : Vector2) : table

    if typeof(resolution) ~= "Vector2" then

        error("In the resolution parameter of the Render2D createRenderer you must use a Vector2!")
    
    elseif typeof(windowPosition) ~= "Vector2" then

        error("In the windowPosition parameter of the Render2D createRenderer you must use a Vector2!")
        
    elseif typeof(resolution) ~= "Vector2" then

        error("In the windowSize parameter of the Render2D createRenderer you must use a Vector2!")
    end

    table.insert(Render2D.Renderers, {

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
    })

    return #Render2D.Renderers
end

function Render2D.init(ID : number, player : Instance)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D init you must use a number!")
    
    elseif typeof(player) ~= "Instance" then

        error("In the player parameter of the Render2D init you must use a Player!")
    end


    Render2D.Renderers[ID].player = player
    
    Render2D.Renderers[ID].screenGui = Instance.new("ScreenGui")
    Render2D.Renderers[ID].screenGui.Parent = Render2D.Renderers[ID].player.PlayerGui

    Render2D.Renderers[ID].backgroundFrame = Instance.new("Frame")
    Render2D.Renderers[ID].backgroundFrame.BackgroundColor3 = Render2D.Renderers[ID].backgroundColor
    Render2D.Renderers[ID].backgroundFrame.Position = UDim2.new(Render2D.Renderers[ID].windowPosition.X, 0, Render2D.Renderers[ID].windowPosition.Y, 0)
    Render2D.Renderers[ID].backgroundFrame.Size = UDim2.new(Render2D.Renderers[ID].windowSize.X, 0, Render2D.Renderers[ID].windowSize.Y, 0)
    Render2D.Renderers[ID].backgroundFrame.Parent = Render2D.Renderers[ID].screenGui
end

function Render2D.setResolution(ID : number, resolution : Vector2)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D setResolution you must use a number!")

    elseif typeof(resolution) ~= "Vector2" then

        error("In the resolution parameter of the Render2D setResolution you must use a Vector2!")
    end

    Render2D.Renderers[ID].resolution = resolution
end

function Render2D.getResolution(ID : number) : Vector2

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D getResolution you must use a number!")
    end

    return Render2D.Renderers[ID].resolution
end

function Render2D.getGui(ID : number) : Instance

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D getGui you must use a number!")
    end

    return Render2D.Renderers[ID].screenGui
end

function Render2D.delete(ID : number)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D delete you must use a number!")
    end

    table.remove(Render2D.Renderers, ID)
end

function Render2D.drawPixel(ID : number, position : Vector2, color : Color3) : Instance

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D drawPixel you must use a number!")

    elseif typeof(position) ~= "Vector2" then

        error("In the position parameter of the Render2D drawPixel you must use a Vector2!")
    
    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the Render2D drawPixel you must use a Color3!")
    end


    Render2D.Renderers[ID].currentPixelIndex += 1

    local pixel

    if Render2D.Renderers[ID].currentPixelIndex > #Render2D.Renderers[ID].componentsBuffer.pixels then
        pixel = Instance.new("Frame")
        table.insert(Render2D.Renderers[ID].componentsBuffer.pixels, pixel)
    end

    pixel = Render2D.Renderers[ID].componentsBuffer.pixels[Render2D.Renderers[ID].currentPixelIndex]
    pixel.Parent = Render2D.Renderers[ID].screenGui

    local xScale = position.X / Render2D.Renderers[ID].resolution.X
    local yScale = position.Y / Render2D.Renderers[ID].resolution.Y
    local widthScale = Render2D.Renderers[ID].windowSize.X / Render2D.Renderers[ID].resolution.X
    local heightScale = Render2D.Renderers[ID].windowSize.Y / Render2D.Renderers[ID].resolution.Y

    pixel.Position = UDim2.new(xScale + Render2D.Renderers[ID].windowPosition.X, 0, yScale + Render2D.Renderers[ID].windowPosition.Y, 0)
    pixel.Size = UDim2.new(widthScale, 0, heightScale, 0)
    pixel.Transparency = 1
    pixel.BackgroundColor3 = color
    pixel.BorderSizePixel = 0

    return pixel
end

function Render2D.drawCircle(ID : number, position : Vector2, radius : number, fill : bool, color : Color)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D drawCircle you must use a number!")

    elseif typeof(position) ~= "Vector2" then

        error("In the position parameter of the Render2D drawCircle you must use a Vector2!")
    
    elseif typeof(radius) ~= "number" then

        error("In the radius parameter of the Render2D drawCircle you must use a number!")
        
    elseif typeof(fill) ~= "boolean" then

        error("In the fill parameter of the Render2D drawCircle you must use a Bool!")

    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the Render2D drawCircle you must use a Color3!")
    end

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

                    Render2D.drawPixel(ID, Vector2.new(math.floor(i) + Render2D.Renderers[ID].windowPosition.X, math.floor(j) + Render2D.Renderers[ID].windowPosition.Y), color)
                else

                    if distanceSquared >= (radius - 1) * (radius - 1) then
                        Render2D.drawPixel(ID, Vector2.new(math.floor(i) + Render2D.Renderers[ID].windowPosition.X, math.floor(j) + Render2D.Renderers[ID].windowPosition.Y), color)
                    end
                end
            end
        end
    end
end

function Render2D.drawLine(ID : number, position1 : Vector2, position2 : Vector2, thickness : number, color : Color3)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D drawLine you must use a number!")

    elseif typeof(position1) ~= "Vector2" then

        error("In the position1 parameter of the Render2D drawLine you must use a Vector2!")
    
    elseif typeof(position2) ~= "Vector2" then

        error("In the position2 parameter of the Render2D drawLine you must use a Vector2!")
        
    elseif typeof(thickness) ~= "number" then

        error("In the thickness parameter of the Render2D drawLine you must use a number!")

    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the Render2D drawLine you must use a Color3!")
    end

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

                if px >= 0 and px < Render2D.Renderers[ID].resolution.X and py >= 0 and py < Render2D.Renderers[ID].resolution.Y then
                    Render2D.drawPixel(ID, Vector2.new(px + Render2D.Renderers[ID].windowPosition.X, py + Render2D.Renderers[ID].windowPosition.Y), color)
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

function Render2D.drawTriangle(ID : number, position1 : Vector2, position2 : Vector2, position3 : Vector2, thickness : number, fill : bool, color : Color3)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D drawTriangle you must use a number!")

    elseif typeof(position1) ~= "Vector2" then

        error("In the position1 parameter of the Render2D drawTriangle you must use a Vector2!")
    elseif typeof(position2) ~= "Vector2" then

        error("In the position2 parameter of the Render2D drawTriangle you must use a Vector2!")
    elseif typeof(position3) ~= "Vector2" then

        error("In the position3 parameter of the Render2D drawTriangle you must use a Vector2!")
    elseif typeof(thickness) ~= "number" then

        error("In the thickness parameter of the Render2D drawTriangle you must use a number!")
    elseif typeof(fill) ~= "boolean" then

        error("In the fill parameter of the Render2D drawTriangle you must use a Bool!")
    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the Render2D drawTriangle you must use a Color3!")
    end

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
                Render2D.drawPixel(ID, Vector2.new(x, y), color)
            end
        end
    end

    Render2D.drawLine(ID, Vector2.new(position1.X, position1.Y), Vector2.new(position2.X, position2.Y), thickness, color)
    Render2D.drawLine(ID, Vector2.new(position2.X, position2.Y), Vector2.new(position3.X, position3.Y), thickness, color)
    Render2D.drawLine(ID, Vector2.new(position3.X, position3.Y), Vector2.new(position1.X, position1.Y), thickness, color)
end

function Render2D.drawRectangle(ID : number, position : Vector2, size : Vector2, color : Color3) : instance
    
    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D drawRectangle you must use a number!")

    elseif typeof(position) ~= "Vector2" then

        error("In the position parameter of the Render2D drawRectangle you must use a Vector2!")
    elseif typeof(size) ~= "Vector2" then

        error("In the size parameter of the Render2D drawRectangle you must use a Vector2!")
    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the Render2D drawRectangle you must use a Color3!")
    end

    Render2D.Renderers[ID].currentRectangleIndex += 1

    local rectangle

    if Render2D.Renderers[ID].currentRectangleIndex > #Render2D.Renderers[ID].componentsBuffer.rectangles then
        rectangle = Instance.new("Frame")
        table.insert(Render2D.Renderers[ID].componentsBuffer.rectangles, rectangle)
    end

    rectangle = Render2D.Renderers[ID].componentsBuffer.rectangles[Render2D.Renderers[ID].currentRectangleIndex]
    rectangle.Parent = Render2D.Renderers[ID].screenGui
    
    local xScale = position.X / Render2D.Renderers[ID].resolution.X
    local yScale = position.Y / Render2D.Renderers[ID].resolution.Y
    local widthScale = size.X / Render2D.Renderers[ID].resolution.X
    local heightScale = size.Y / Render2D.Renderers[ID].resolution.Y

    rectangle.Position = UDim2.new((xScale * Render2D.Renderers[ID].windowSize.X) + Render2D.Renderers[ID].windowPosition.X, 0, (yScale * Render2D.Renderers[ID].windowSize.Y) + Render2D.Renderers[ID].windowPosition.Y, 0)
    rectangle.Size = UDim2.new(widthScale * Render2D.Renderers[ID].windowSize.X, 0, heightScale * Render2D.Renderers[ID].windowSize.Y, 0)
    rectangle.Transparency = 1
    rectangle.BackgroundColor3 = color
    rectangle.BorderSizePixel = 0

    return rectangle
end

function Render2D.clear(ID : number, color : Color3)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D clear you must use a number!")
    
    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the Render2D clear you must use a Color3!")
    end

    Render2D.Renderers[ID].backgroundColor = color

    for index, component in next, Render2D.Renderers[ID].componentsBuffer.rectangles do

        component.Transparency = 1
    end

    for index, component in next, Render2D.Renderers[ID].componentsBuffer.pixels do

        component.Transparency = 1
    end
end

function Render2D.update(ID : number)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the Render2D update you must use a number!")
    end

    Render2D.Renderers[ID].backgroundFrame.BackgroundColor3 = Render2D.Renderers[ID].backgroundColor

    for index, component in next, Render2D.Renderers[ID].componentsBuffer.rectangles do

        component.Transparency = 0
    end

    for index, component in next, Render2D.Renderers[ID].componentsBuffer.pixels do

        component.Transparency = 0
    end

    Render2D.Renderers[ID].currentPixelIndex = 0
    Render2D.Renderers[ID].currentRectangleIndex = 0

    wait()
end

return Render2D