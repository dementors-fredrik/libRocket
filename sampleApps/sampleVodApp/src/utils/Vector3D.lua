-- Vector3D (with projection support) implementation for Lua
-- Author : Fredrik Andersson

Vector3D = {}
Vector3D.__index = Vector3D

Vector3D.Project = function(self, cameraVector) 
	local totalZ = (self.z - cameraVector.z)
	if totalZ == 0 then
		totalZ = totalZ + 0.001
	end
	local x = ((self.x - cameraVector.x) * 400) / totalZ
    local y = ((self.y - cameraVector.y) * 400) / totalZ
    return Vector2D.Create(x,y, totalZ)
end

Vector3D.Invert = function (self)
	local v = Vector3D.Create(self.x, self.y, self.z)
	v.x = -v.x
	v.y = -v.y
	v.z = -v.z
	return v
end

Vector3D.EulerRotate = function (self, yaw, pitch, roll)
	local ox = self.x;
	local oy = self.y;
	local oz = self.z;

    local x1 = ox * math.cos(roll) - oy * math.sin(roll);
    local y1 = oy * math.cos(roll) + ox * math.sin(roll);
    local z1 = oz; 

    local x2 = x1 * math.cos(yaw) - z1 * math.sin(yaw);
    local y2 = y1;
    local z2 = z1 * math.cos(yaw) + x1 * math.sin(yaw);

    local x3 = x2;
    local y3 = y2 * math.cos(pitch) - z2 * math.sin(pitch);
    local z3 = z2 * math.cos(pitch) + y2 * math.sin(pitch);

	return Vector3D.Create(x3, y3, z3)
end

Vector3D.Length = function (self)
	return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end

Vector3D.Scale = function (self, aNumber)
	local v = Vector3D.Create(self.x * aNumber, self.y * aNumber, self.z * aNumber)
	return v
end

Vector3D.Dot = function (self, Vector3d_aVector)
	return self.x * Vector3d_aVector.x + self.y * Vector3d_aVector.y + self.z * Vector3d_aVector.z
end

Vector3D.Cross = function (self, Vector3d_aVector)
	return Vector3D.Create(self.y * Vector3d_aVector.z - self.z * Vector3d_aVector.y,
						   self.z * Vector3d_aVector.x - self.x * Vector3d_aVector.z,
						   self.x * Vector3d_aVector.y - self.y * Vector3d_aVector.x) 
end

Vector3D.ToString = function (self)
	return "x: " .. self.x .. " y: " .. self.y .. " z: " .. self.z
end

Vector3D.Create = function (x, y, z) 
	local i = {}
	setmetatable(i, Vector3D)
	i.x = x
	i.y = y
	i.z = z

	return i
end

