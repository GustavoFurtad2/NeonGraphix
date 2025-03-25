local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render = NeonGraphix.Renderer.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT, 1, 1)

render:init(game.Players.LocalPlayer)

game:GetService("RunService").RenderStepped:Connect(function()
	
	render:clear()
	
	render:setBackgroundColor(Color3.new(0, 0, 0))
	
	render:drawPixel(1, 1, Color3.new(1, 0, 0))
	
	render:update()
end)