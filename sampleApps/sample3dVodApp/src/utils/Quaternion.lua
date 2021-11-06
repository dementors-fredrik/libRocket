Quaternion = {}
Quaternion.__index = Quaternion

Quaternion._generateInstance = function () 
	local q = {}
	setmetatable(q, Quaternion)
	return q
end

Quaternion.Clone = function (self)
	local q = Quaternion._generateInstance()
	q.w = self.w
	q.v = Vector3D.Create(self.v.x, self.v.y, self.v.z)
	return q
end

Quaternion.Invert = function (self) 
	local q = Quaternion._generateInstance()
	q.w = self.w
	q.v = self.v:Invert()
	return q
end

Quaternion.Mult = function (self, Quaternion_aQuaternion)
	local q = Quaternion._generateInstance()
	q.w = self.w * Quaternion_aQuaternion.w - self.v:Dot(Quaternion_aQuaternion.v)

	local tV1 = self.v:Scale(Quaternion_aQuaternion.w)
	local tV2 = Quaternion_aQuaternion.v:Scale(self.w)
	local tV3 = self.v:Cross(Quaternion_aQuaternion.v)

	q.v = Vector3D.Create(tV1.x + tV2.x + tV3.x,
						  tV1.y + tV2.y + tV3.y,
						  tV1.z + tV2.z + tV3.z)
	return q
end

Quaternion.RotateVector = function (self, Vector3D_aVector)

	local tmpV = self.v:Cross(Vector3D_aVector)
	local tmpV2 = tmpV:Scale(2*self.w) 
	local tmpV3 = self.v:Cross(tmpV):Scale(2)
	local v = Vector3D.Create(Vector3D_aVector.x + tmpV2.x + tmpV3.x,
						      Vector3D_aVector.y + tmpV2.y + tmpV3.y,
						      Vector3D_aVector.z + tmpV2.z + tmpV3.z)
	return v
end

Quaternion.Create = function (angle, Vector3D_aVector)
	local q = Quaternion._generateInstance()

	q.w = math.cos(angle/2)
	q.v = Vector3D.Create(Vector3D_aVector.x * math.sin(angle/2),
      					  Vector3D_aVector.y * math.sin(angle/2),
						  Vector3D_aVector.z * math.sin(angle/2))
	return q
end

Quaternion.ToString = function (self)
	return "w:" .. self.w .. " " .. self.v:ToString() 
end

Quaternion.Pow = function (self, power) 
	local angle, axis = self:GetAngleAndAxis()
	return Quaternion.Create(angle * power, axis)

end

Quaternion.Slerp = function (self, Quaternion_target, interpolationT)
	return Quaternion_target:Mult(self:Invert()):Pow(interpolationT):Mult(self)
end

Quaternion.GetAngleAndAxis = function (self) 
	local axis = nil 

	if self.v:Normalized():Length() > 0.0001 then
		axis = self.v:Normalized()
	else
		axis = Vector3D.Create(1, 0, 0)
	end	

	return math.acos(self.w)*2, axis
end

Quaternion.CreateFromEuler = function (roll, pitch, yaw)
	local q = Quaternion._generateInstance()

	local cr = math.cos(roll/2)
	local cp = math.cos(pitch/2)
	local cy = math.cos(yaw/2)

	local sr = math.sin(roll/2)
	local sp = math.sin(pitch/2)
	local sy = math.sin(yaw/2)

	local cpcy = cp * cy
	local spsy = sp * sy

	q.w = cr * cpcy + sr * spsy
	q.v = Vector3D.Create(sr * cpcy - cr * spsy,
						  cr * sp * cy + sr * cp * sy,
						  cr * cp * sy - sr * sp * cy)
	return q
end
