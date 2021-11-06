Matrix = {}
Matrix.__index = Matrix

Matrix.Identity = function (self) 
	self._matrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	return self	
end

Matrix.Create = function () 
	local i = {}
	setmetatable(i, Matrix)
	return i:Identity();
end

