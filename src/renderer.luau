local Renderer = {}
Renderer.__index = Renderer

local totalRenderers = 0

function Renderer.new(width, height)

    totalRenderers += 1

    local Renderer = {
        width = width or 1024,
        height = height or 768
    }

    Renderer.pixelWidthSize = 0.5 / width
    Renderer.pixelHeightSize = 1 / height

    Renderer.screenGui = Instance.new("ScreenGui")

    Renderer.screenGui.Name = totalRenderers
    Renderer.screenGui.Parent = script

    local r = 0
    local g = 0
    local b = 0

    local frame = Instance.new("Frame")

    frame.Parent = Renderer.screenGui

    frame.Size = UDim2.new(1, 0, 1, 0)

    return Renderer
end

function Renderer:setResolution(width, height)

    self.width, self.height = width, height
end

function Renderer:getResolution()
    return self.width, self.height
end


return Renderer