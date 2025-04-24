local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render2D = NeonGraphix.render2D
local rendererID = render2D.createRenderer(Vector2.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT), Vector2.new(0, 0), Vector2.new(1, 1))

render2D.init(rendererID, game.Players.LocalPlayer)

local angle = 0

local BLACK, YELLOW, BLUE = Color3.new(0, 0, 0), Color3.new(1, 1, 0), Color3.new(0, 0, 1)

game:GetService("RunService").RenderStepped:Connect(function()

	render2D.clear(rendererID, BLACK)

	render2D.drawCircle(rendererID, Vector2.new(160, 124), 10, true, YELLOW)

	render2D.drawCircle(rendererID, Vector2.new(170 + math.cos(angle) * 60, 120 + math.sin(angle) * 60), 3, true, BLUE)

	angle += 0.05

	if angle >= 360 then
		angle = 0
	end

	render2D.update(rendererID)
end)