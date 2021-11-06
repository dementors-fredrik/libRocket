-- Vector2D implementation for Lua
-- Author : Fredrik Andersson

Vector2D = {}
Vector2D.__index = Vector2D

Vector2D.Translate = function(self, x, y)
	return Vector2D.Create(self.x + x, self.y + y, self.depth)
end

Vector2D.Rotate = function (self, angle)
	local ox = self.x;
	local oy = self.y;

    local x1 = ox * math.cos(angle) - oy * math.sin(angle);
    local y1 = oy * math.cos(angle) + ox * math.sin(angle);

	return Vector2D.Create(x1, y1, self.depth)
end

Vector2D.ToString = function (self)
	return " x: " .. self.x .. " y: " .. self.y
end

Vector2D.Create = function (x, y, depth) 
	local i = {}
	setmetatable(i, Vector2D)
	i.x = x
	i.y = y
	i.depth = depth
	return i
end

