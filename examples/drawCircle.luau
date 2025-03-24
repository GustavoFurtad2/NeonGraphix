local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

game:GetService("RunService").RenderStepped:Connect(function()
	
	render:clear()
	
	render:setBackgroundColor(Color3.new(0, 0, 0))
	
	render:drawCircle(20, 20, 10, false, Color3.new(1, 0, 0))
	
	render:update()
end)