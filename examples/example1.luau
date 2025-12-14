local rendererModule = require(game.ReplicatedStorage.NeonGraphix.Renderer)

local width, height = 320, 240

local gameRenderer = rendererModule.new(width, height)

local frame = Instance.new("ImageLabel")
frame.Size = UDim2.fromOffset(width, height)
frame.Parent = script.Parent

frame.ImageContent = Content.fromObject(gameRenderer:getEditableImage())

gameRenderer:setColorRGBA(255, 255, 0, 255)

game:GetService("RunService").RenderStepped:Connect(function()
	 
	gameRenderer:clear()
	
	gameRenderer:drawPixel(10, 10)
	gameRenderer:drawRectangle(20, 10, 50, 50)
	gameRenderer:drawFilledRectangle(80, 10, 50, 50)
	gameRenderer:drawLine(140, 10, 190, 60, 1)
	gameRenderer:drawTriangle(200, 10, 235, 60, 215, 45)
	gameRenderer:drawFilledTriangle(10, 100, 50, 150, 25, 135)
	gameRenderer:drawCircle(80, 125, 25)
	gameRenderer:drawFilledCircle(140, 125, 25)

	gameRenderer:update()
end)