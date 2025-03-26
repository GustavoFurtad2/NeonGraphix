local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render = NeonGraphix.Renderer2D.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT, 0, 0, 1, 1)

render:init(game.Players.LocalPlayer)

game:GetService("RunService").RenderStepped:Connect(function()
	
	render:clear(Color3.new(0, 0, 0))
		
	render:drawRectangle(10, 10, 10, 10, Color3.new(1, 0, 0))
	
	render:update()
end)