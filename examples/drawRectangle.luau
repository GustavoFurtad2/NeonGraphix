local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local SCREEN_WIDTH, SCREEN_HEIGHT = 320, 248

local render = NeonGraphix.Renderer.new(SCREEN_WIDTH, SCREEN_HEIGHT)

render:init(game.Players.LocalPlayer)

game:GetService("RunService").RenderStepped:Connect(function()
	
	render:clear()
	
	render:setBackgroundColor(Color3.new(0, 0, 0))
	
	render:drawRectangle(10, 10, 10, 10, Color3.new(1, 0, 0))
	
	render:update()
end)