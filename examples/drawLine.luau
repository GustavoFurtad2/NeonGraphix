local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

game:GetService("RunService").RenderStepped:Connect(function()
	
	render:clear()
	
	render:setBackgroundColor(Color3.new(0, 0, 0))
	
	render:drawLine(1, 1, 320, 248, 1, Color3.new(1, 0, 0))
	
	render:update()
end)