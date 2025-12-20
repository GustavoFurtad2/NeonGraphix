local Renderer = require(game.ReplicatedStorage.NeonGraphix.Renderer)
local Mat4 = require(game.ReplicatedStorage.NeonGraphix.Mat4)
local Transform = require(game.ReplicatedStorage.NeonGraphix.Transform)

local width, height = 320, 240

local renderer = Renderer.new(width, height)

local frame = Instance.new("ImageLabel")
frame.Size = UDim2.fromOffset(width, height)
frame.Parent = script.Parent

frame.ImageContent = Content.fromObject(renderer:getEditableImage())

renderer:setColorRGBA(255, 255, 0, 255)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local model = {
	{
		{x = -40, y = -20, z = 0},
		{x =   0, y = -20, z = 0},
		{x = -20, y =  20, z = 0}
	},
	{
		{x =   0, y = -20, z = 0},
		{x =  40, y = -20, z = 0},
		{x =  20, y =  20, z = 0}
	},
	{
		{x = -20, y = 20, z = 0},
		{x =  20, y = 20, z = 0},
		{x =   0, y = 60, z = 0}
	}
}

local objs = {}

for _, polygon in next, model do
	
	local obj = Transform.new(polygon)
	
	obj.position.z = 120
	obj.scale.x = 1.5
	obj.scale.y = 1.5
	obj.scale.z = 1.5
	
	table.insert(objs, obj)
end


local function update(dt)
	
	for _, obj in next, objs do
	
		obj.rotation.y += dt
	
		obj:apply()
	end
end

local function draw()
	
	renderer:clear()	
		
	for _, obj in next, objs do

		obj:draw(renderer)
	end
	
	renderer:update()
end

RunService.RenderStepped:Connect(function(dt)
	update(dt)
	draw()
end)