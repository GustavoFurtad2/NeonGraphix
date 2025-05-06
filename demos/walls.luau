local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RaycastRender = NeonGraphix.raycastRender
local Camera = NeonGraphix.camera

local cameraID = Camera.createCamera(game.Players.LocalPlayer, Vector3.new(-169, 250, 0), 355, 150, 500 * 100, 4)
local raycastRenderID = RaycastRender.createRenderer(game.Players.LocalPlayer, Camera.getCamera(cameraID), Vector2.new(320, 240), Vector2.new(0, 0), Vector2.new(1, 1))

local BLACK, YELLOW = Color3.new(0, 0, 0), Color3.new(1, 1, 0)

local sector1 = RaycastRender.createSector(10, 0, YELLOW)

local sectorsQueue = {}

local sectorData = {
	Vector2.new(70, 220), Vector2.new(100, 240),
	Vector2.new(100, 240), Vector2.new(100, 240),
	Vector2.new(100, 240), Vector2.new(70, 240),
	Vector2.new(70, 240), Vector2.new(70, 220),
}

for i = 1, #sectorData, 2 do

	local wall = RaycastRender.createWall(sectorData[i], sectorData[i + 1], Vector2.new(20, 10))
	RaycastRender.addWallToSector(sector1, wall)
end

RaycastRender.addSectorToQueue(sectorsQueue, sector1)


local UIS = game:GetService("UserInputService")

local cos, sin = {}, {}

for i = 0, 360 do
	
	cos[i], sin[i] = math.cos(i / 180 * math.pi), math.sin(i / 180 * math.pi)
end

local function update()
	
	local camera = RaycastRender.Renderers[raycastRenderID].camera
	
	if UIS:IsKeyDown(Enum.KeyCode.D) then
		
		camera.angle -= 1
		
		if camera.angle < 0 then
			camera.angle += 360
		end
		
	elseif UIS:IsKeyDown(Enum.KeyCode.A) then
		
		camera.angle += 1
		
		if camera.angle > 359 then
			camera.angle -= 360
		end
	end

	
	if UIS:IsKeyDown(Enum.KeyCode.W) then
		
		local directionX = cos[camera.angle] * 5
		local directionY = sin[camera.angle] * 5
		
		camera.position += Vector3.new(directionX, directionY, 0)

	elseif UIS:IsKeyDown(Enum.KeyCode.S) then
		
		local directionX = cos[camera.angle] * 5
		local directionY = sin[camera.angle] * 5
		camera.position -= Vector3.new(directionX, directionY, 0)
	end
	
	if UIS:IsKeyDown(Enum.KeyCode.Up) then
		
		camera.position += Vector3.new(0, 0, 150)
		
	elseif UIS:IsKeyDown(Enum.KeyCode.Down) then
		
		camera.position -= Vector3.new(0, 0, 150)
	end
end

game:GetService("RunService").RenderStepped:Connect(function()
	
	RaycastRender.clear(raycastRenderID, BLACK)
	
	update()
	
	RaycastRender.renderSectors(raycastRenderID, sectorsQueue, 1)
		
	RaycastRender.update(raycastRenderID)
end)