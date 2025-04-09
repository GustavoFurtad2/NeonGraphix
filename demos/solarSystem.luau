local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render = NeonGraphix.Renderer2D.new(Vector2.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT), Vector2.new(0, 0), Vector2.new(1, 1))

render:init(game.Players.LocalPlayer)

local angle = 0

game:GetService("RunService").RenderStepped:Connect(function()

    render:clear(Color3.new(0, 0, 0))

    render:drawCircle(Vector2.new(160, 124), 10, true, Color3.new(1, 1, 0))
	
    render:drawCircle(Vector2.new(170 + math.cos(angle) * 60, 120 + math.sin(angle) * 60), 3, true, Color3.new(0, 0, 1))
	
    angle += 0.05
		
    if angle >= 360 then
        angle = 0
    end

    render:update()
end)