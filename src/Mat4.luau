local Mat4 = {}

function Mat4.identity()
	
	return {
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	}
end

function Mat4.translate(x, y, z)
	
	return {
		1, 0, 0, x,
		0, 1, 0, y,
		0, 0, 1, z,
		0, 0, 0, 1
	}
end

function Mat4.scale(sx, sy, sz)
	
	return {
		sx, 0, 0, 0,
		0, sy, 0, 0,
		0, 0, sz, 0,
		0, 0, 0,  1
	}
end

function Mat4.rotateX(a)
	
	local c = math.cos(a)
	local s = math.sin(a)
	
	return {
		1, 0,  0, 0,
		0, c, -s, 0,
		0, s,  c, 0,
		0, 0,  0, 1
	}
end

function Mat4.rotateY(a)
	
	local c = math.cos(a)
	local s = math.sin(a)
	
	return {
		c, 0,  s, 0,
		0, 1,  0, 0,
		-s, 0, c, 0,
		0, 0,  0, 1
	}
end

function Mat4.rotateZ(a)
	
	local c = math.cos(a)
	local s = math.sin(a)
	
	return {
		c, -s, 0, 0,
		s,  c, 0, 0,
		0,  0, 1, 0,
		0,  0, 0, 1
	}
end

function Mat4.perspective(d)
	
	return {
		d, 0, 0, 0,
		0, d, 0, 0,
		0, 0, 0, 1,
		0, 0, 1, 0
	}
end

function Mat4.mul(a, b)
	
	local r = {}
	
	for row = 0, 3 do
		
		for col = 0, 3 do
			
			local sum = 0
			
			for k = 0, 3 do
				
				sum += a[row * 4 + k + 1] * b[k * 4 + col + 1]
			end
			
			r[row * 4 + col + 1] = sum
		end
	end
	
	return r
end

function Mat4.mulVec3(m, v)

	local x = v.x * m[1] + v.y * m[2] + v.z * m[3] + m[4]
	local y = v.x * m[5] + v.y * m[6] + v.z * m[7] + m[8]
	local z = v.x * m[9] + v.y * m[10] + v.z * m[11] + m[12]

	return {x = x, y = y, z = z}
end

function Mat4.mulVec4(m, v)

	local x = v.x * m[1] + v.y * m[2] + v.z * m[3] + m[4]
	local y = v.x * m[5] + v.y * m[6] + v.z * m[7] + m[8]
	local z = v.x * m[9] + v.y * m[10] + v.z * m[11] + m[12]
	local w = v.x * m[13] + v.y * m[14] + v.z * m[15] + m[16]

	return {x = x, y = y, z = z, w = w}
end


return Mat4