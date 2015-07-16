require("class")
Vec2 = class(function(self, x, y)
	self.x = x
	self.y = y
end)

function Vec2:__add(v) 
	return Vec2(self.x + v.x, self.y + v.y)
end

function Vec2:__sub(v) 
	return Vec2(self.x - v.x, self.y - v.y)
end

function Vec2:__eq(v)
	return self.x == v.x and self.y == v.y
end

function Vec2:set(v)
	self.x = v.x
	self.y = v.y
end

function Vec2:clone()
	return Vec2(self.x, self.y)
end

function Vec2:inverse()
	return Vec2(-self.x, -self.y)
end

function Vec2:fliped()
	return Vec2(self.y, self.x)
end

-- 'fast' magnitude
function Vec2:sqrMagnitude()
	return math.abs(self.x) + math.abs(self.y)
end

function Vec2:magnitude()
	return math.sqrt(self.x*self.x, self.y*self.y);
end

-- Predefine constants
Vec2.ZERO = Vec2(0, 0)
Vec2.ONE = Vec2(1, 1)

Vec2.UP = Vec2(0, -1)
Vec2.DOWN = Vec2(0, 1)
Vec2.LEFT = Vec2(-1, 0)
Vec2.RIGHT = Vec2(1, 0)