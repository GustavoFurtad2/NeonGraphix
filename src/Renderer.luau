local AssetService = game:GetService("AssetService")

local Renderer = {}

local MASK_R   = 0xFFFFFF00
local MASK_G   = 0xFFFF00FF
local MASK_B   = 0xFF00FFFF
local MASK_A   = 0x00FFFFFF
local MASK_RG  = 0xFFFF0000
local MASK_RB  = 0xFF00FF00
local MASK_GB  = 0xFF0000FF
local MASK_RGB = 0xFF000000

local function clamp8(value : number)

	if value < 0 then
		return 0
	elseif value > 255 then
		return 255
	end

	return value
end

function Renderer.new(width : number, height : number)

	local self = table.clone(Renderer)

	self.width = math.floor(width)
	self.height = math.floor(height)
	self.size = self.width * self.height

	self.frameBufferSize = self.size * 4

	self.frameBuffer = buffer.create(self.frameBufferSize)
	self.cleanFrameBuffer = buffer.create(self.frameBufferSize)

	self.editableImage = AssetService:CreateEditableImage({Size = Vector2.new(self.width, self.height)})

	self.currentColor = 0

	buffer.copy(self.cleanFrameBuffer, 0, self.frameBuffer, 0)

	return self
end

function Renderer:clear()

	buffer.copy(self.frameBuffer,  0, self.cleanFrameBuffer, 0)
end

function Renderer:setColorR(r : number)

	self.currentColor = bit32.bor(
		bit32.band(self.currentColor, MASK_R),
		r
	)
end

function Renderer:setColorG(g : number)

	self.currentColor = bit32.bor(
		bit32.band(self.currentColor, MASK_G), 
		bit32.lshift(g, 8)
	)
end

function Renderer:setColorB(b : number)

	self.currentColor = bit32.bor(
		bit32.band(self.currentColor, 0xFF00FFFF), 
		bit32.lshift(b, 16)
	)
end

function Renderer:setColorA(a : number)

	a = clamp8(a)

	self.currentColor = bit32.bor(bit32.band(self.currentColor, MASK_A), bit32.lshift(a, 24))
end

function Renderer:setColorRG(r : number, g : number)

	r = clamp8(r)
	g = clamp8(g)

	self.currentColor = bit32.bor(bit32.band(self.currentColor, MASK_RG), r, bit32.lshift(g, 8))
end

function Renderer:setColorRB(r : number, b : number)

	r = clamp8(r)
	g = clamp8(b)

	self.currentColor = bit32.bor(bit32.band(self.currentColor, MASK_RB), r, bit32.lshift(b, 16))
end

function Renderer:setColorGB(g : number, b : number)

	g = clamp8(g)
	b = clamp8(b)

	self.currentColor = bit32.bor(bit32.band(self.currentColor, MASK_GB), bit32.lshift(g, 8), bit32.lshift(b, 16))
end

function Renderer:setColorRGB(r : number, g : number, b : number)

	r = clamp8(r)
	g = clamp8(g)
	b = clamp8(b)

	self.currentColor = bit32.bor(bit32.band(self.currentColor, MASK_RGB), r, bit32.lshift(g, 8), bit32.lshift(b, 16))
end

function Renderer:setColorRGBA(r : number, g : number, b : number, a : number)

	r = clamp8(r)
	g = clamp8(g)
	b = clamp8(b)
	a = clamp8(a)

	self.currentColor = bit32.bor(r, bit32.lshift(g, 8), bit32.lshift(b, 16), bit32.lshift(a, 24))
end

function Renderer:drawPixel(x : number, y : number)

	if x < 0 or x >= self.width or y < 0 or y >= self.height then
		return
	end
	
	x = math.floor(x)
	y = math.floor(y)

	buffer.writeu32(self.frameBuffer, (y * self.width + x) * 4, self.currentColor)
end


function Renderer:drawRectangle(x : number, y : number, w : number, h : number)
	
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)

	local x1 = math.max(x, 0)
	local y1 = math.max(y, 0)
	local x2 = math.min(x + w, self.width - 1)
	local y2 = math.min(y + h - 1, self.height)

	if x1 > x2 or y1 > y2 then
		return
	end
	
	for px = x1, x2 do

		buffer.writeu32(self.frameBuffer, (y1 * self.width + px) * 4, self.currentColor)
		buffer.writeu32(self.frameBuffer, (y2 * self.width + px) * 4, self.currentColor)
	end

	for py = y1, y2 do

		buffer.writeu32(self.frameBuffer, (py * self.width + x1) * 4, self.currentColor)
		buffer.writeu32(self.frameBuffer, (py * self.width + x2) * 4, self.currentColor)
	end	
end

function Renderer:drawFilledRectangle(x : number, y : number, w : number, h : number)
	
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)

	local x1 = math.max(x, 0)
	local y1 = math.max(y, 0)
	local x2 = math.min(x + w, self.width - 1)
	local y2 = math.min(y + h - 1, self.height)

	if x1 > x2 or y1 > y2 then
		return
	end

	for py = y1, y2 do

		for px = x1, x2 do

			buffer.writeu32(self.frameBuffer, (py * self.width + px) * 4, self.currentColor)
		end
	end
end

local INSIDE = 0
local LEFT   = 1
local RIGHT  = 2
local BOTTOM = 4
local TOP    = 8

local function computeOutCode(x : number, y : number, w : number, h : number)

	local code = INSIDE

	if x < 0 then

		code = bit32.bor(code, LEFT)
	elseif x >= w then

		code = bit32.bor(code, RIGHT)
	end

	if y < 0 then

		code = bit32.bor(code, TOP)
	elseif y >= h then

		code = bit32.bor(code, BOTTOM)
	end

	return code
end

function Renderer:drawLine(x1 : number, y1 : number, x2 : number, y2 : number, thickness : number)
	
	thickness = math.floor(thickness)
	
	if thickness == 0 then
		return
	end
	
	x1, y1 = math.floor(x1), math.floor(y1)
	x2, y2 = math.floor(x2), math.floor(y2)
	
	local outcode1 = computeOutCode(x1, y1, self.width, self.height)
	local outcode2 = computeOutCode(x2, y2, self.width, self.height)

	while true do

		if bit32.bor(outcode1, outcode2) == 0 then

			break
		elseif bit32.band(outcode1, outcode2) ~= 0 then

			return
		else

			local outcodeOut = (outcode1 ~= 0) and outcode1 or outcode2
			local x, y

			if bit32.band(outcodeOut, TOP) ~= 0 then

				x = x1 + (x2 - x1) * (0 - y1) / (y2 - y1)
				y = 0
			elseif bit32.band(outcodeOut, BOTTOM) ~= 0 then

				x = x1 + (x2 - x1) * ((self.height - 1) - y1) / (y2 - y1)
				y = self.height - 1
			elseif bit32.band(outcodeOut, RIGHT) ~= 0 then

				y = y1 + (y2 - y1) * ((self.width - 1) - x1) / (x2 - x1)
				x = self.width - 1
			elseif bit32.band(outcodeOut, LEFT) ~= 0 then

				y = y1 + (y2 - y1) * (0 - x1) / (x2 - x1)
				x = 0
			end

			if outcodeOut == outcode1 then

				x1, y1 = math.floor(x + 0.5), math.floor(y + 0.5)
				outcode1 = computeOutCode(x1, y1, self.width, self.height)
			else

				x2, y2 = math.floor(x + 0.5), math.floor(y + 0.5)
				outcode2 = computeOutCode(x2, y2, self.width, self.height)
			end
		end
	end

	local dx = math.abs(x2 - x1)
	local dy = math.abs(y2 - y1)

	local sx = (x1 < x2) and 1 or -1
	local sy = (y1 < y2) and 1 or -1

	local err = dx - dy
	local halfThickness = math.floor(thickness / 2)

	while true do

		for tx = -halfThickness, halfThickness do

			for ty = -halfThickness, halfThickness do

				self:drawPixel(x1 + tx, y1 + ty)
			end
		end

		if x1 == x2 and y1 == y2 then
			break
		end

		local e2 = 2 * err

		if e2 > -dy then
			err = err - dy
			x1 = x1 + sx
		end

		if e2 < dx then
			err = err + dx
			y1 = y1 + sy
		end
	end
end

function Renderer:drawTriangle(x1 : number, y1 : number, x2 : number, y2 : number, x3 : number, y3 : number)

	self:drawLine(x1, y1, x2, y2, 1)
	self:drawLine(x2, y2, x3, y3, 1)
	self:drawLine(x3, y3, x1, y1, 1)
end

local function fastDrawLine(self, y, x1, x2)

	if y < 0 or y >= self.height then
		return
	end

	if x1 > x2 then
		x1, x2 = x2, x1
	end

	x1 = math.max(x1, 0)
	x2 = math.min(x2, self.width - 1)

	local row = y * self.width * 4

	for x = x1, x2 do

		buffer.writeu32(self.frameBuffer, row + x * 4, self.currentColor)
	end
end

local function invSlope(xa, ya, xb, yb)

	if ya == yb then
		return 0
	end

	return (xb - xa) / (yb - ya)
end

function Renderer:drawFilledTriangle(x1 : number, y1 : number, x2 : number, y2 : number, x3 : number, y3 : number)

	x1, y1 = math.floor(x1), math.floor(y1)
	x2, y2 = math.floor(x2), math.floor(y2)
	x3, y3 = math.floor(x3), math.floor(y3)

	if (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1) == 0 then
		return
	end

	if y1 > y2 then
		x1, y1, x2, y2 = x2, y2, x1, y1
	end

	if y1 > y3 then
		x1, y1, x3, y3 = x3, y3, x1, y1
	end

	if y2 > y3 then
		x2, y2, x3, y3 = x3, y3, x2, y2
	end

	if y3 < 0 or y1 >= self.height then
		return
	end

	local dx13 = invSlope(x1, y1, x3, y3)
	local dx12 = invSlope(x1, y1, x2, y2)
	local dx23 = invSlope(x2, y2, x3, y3)

	local sx = x1
	local ex = x1

	for y = math.max(y1, 0), math.min(y2 - 1, self.height - 1) do

		fastDrawLine(self, y, math.floor(sx), math.floor(ex))

		sx += dx13
		ex += dx12
	end

	ex = x2

	for y = y2, y3 do

		fastDrawLine(self, y, math.floor(sx), math.floor(ex))

		sx += dx13
		ex += dx23
	end
end

function Renderer:drawCircle(x : number, y : number, radius : number)

	local xStart = math.floor(x - radius)
	local xEnd = math.floor(x + radius)
	local yStart = math.floor(y - radius)
	local yEnd = math.floor(y + radius)

	for i = xStart, xEnd do

		for j = yStart, yEnd do

			local dx = i - x
			local dy = j - y
			local distanceSquared = dx * dx + dy * dy

			if distanceSquared <= radius * radius then

				if distanceSquared >= (radius - 1) * (radius - 1) then
					self:drawPixel(math.floor(i), math.floor(j))
				end
			end
		end
	end
end

function Renderer:drawFilledCircle(x : number, y : number, radius : number)

	local xStart = math.floor(x - radius)
	local xEnd = math.floor(x + radius)
	local yStart = math.floor(y - radius)
	local yEnd = math.floor(y + radius)

	for i = xStart, xEnd do

		for j = yStart, yEnd do

			local dx = i - x
			local dy = j - y
			local distanceSquared = dx * dx + dy * dy

			if distanceSquared <= radius * radius then

				self:drawPixel(math.floor(i), math.floor(j))
			end
		end
	end
end

function Renderer:getEditableImage() : EditableImage

	return self.editableImage
end

function Renderer:update()

	self.editableImage:WritePixelsBuffer(
		Vector2.zero,
		Vector2.new(self.width, self.height),
		self.frameBuffer
	)
end

return Renderer