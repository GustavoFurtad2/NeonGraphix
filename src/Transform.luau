local Transform = {
	
	polygon = nil,
	
	position = {x = 0, y = 0, z = 0},
	rotation = {x = 0, y = 0, z = 0},
	scale = {x = 1, y = 1, z = 1}

}

local Mat4 = require(script.Parent.Mat4)

function Transform.new(polygon)
	
	local self = table.clone(Transform)
	
	self.polygon = polygon
	self._matrix = Mat4.identity() 
	
	return self
end

function Transform:buildMatrix()
	
	local S = Mat4.scale(self.scale.x, self.scale.y, self.scale.z)
	local RX = Mat4.rotateX(self.rotation.x)
	local RY = Mat4.rotateY(self.rotation.y)
	local RZ = Mat4.rotateZ(self.rotation.z)
	local T = Mat4.translate(self.position.x, self.position.y, self.position.z)
	
	return Mat4.mul(
		T,
		Mat4.mul(
			RZ,
			Mat4.mul(
				RY,
				Mat4.mul(RX, S)
			)
		)
	)
end

function Transform:apply()
			
	self._matrix = self:buildMatrix()
	
	self._transformed = {}
			
	for i = 1, 3 do
		self._transformed[i] = Mat4.mulVec3(self._matrix, self.polygon[i])
	end
end

function Transform:draw(renderer)
		
	renderer:drawFilledTri3D(self._transformed)
end

return Transform