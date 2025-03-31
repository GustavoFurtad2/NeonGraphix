local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render = NeonGraphix.Renderer2D.new(Vector2.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT), Vector2.new(0, 0), Vector2.new(1, 1))

render:init(game.Players.LocalPlayer)

game:GetService("RunService").RenderStepped:Connect(function()

	render:clear(Color3.new(0, 0, 0))

	render:drawTriangle(Vector2.new(20, 10), Vector2.new(30, 20), Vector2.new(10, 20), 1, false, Color3.new(1, 1, 0))
	render:drawTriangle(Vector2.new(60, 10), Vector2.new(70, 20), Vector2.new(50, 20), 1, true, Color3.new(1, 1, 0))

	render:update()
end)