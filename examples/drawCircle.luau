local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render2D = NeonGraphix.render2D
local rendererID = render2D.createRenderer(Vector2.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT), Vector2.new(0, 0), Vector2.new(1, 1))

render2D.init(rendererID, game.Players.LocalPlayer)

local BLACK, RED = Color3.new(0, 0, 0), Color3.new(1, 0, 0)

game:GetService("RunService").RenderStepped:Connect(function()

	render2D.clear(rendererID, BLACK)

	render2D.drawCircle(rendererID, Vector2.new(20, 20), 10, false, RED)

	render2D.update(rendererID)
end)