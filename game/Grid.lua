require("class")
require("game/Tile")

GridNode = class(function(self, pos, tile)
	self.pos = pos
	self.tile = tile
	self.color = Color(0,0,0,0)
	self.lerpSpeed = 1
end)

Grid = class(function(self, width, height, wrap)
	self.width = width
	self.height = height
	self.data = {{}}
	self.wrap = wrap
	for x=1,width do
		self.data[x] = {}
		for y=1,height do
			self.data[x][y] = GridNode(Vec2(x, y), EmptyTile)
		end
	end
end)

function Grid:getTile(vec) 
	local cord = self:validateCord(vec)
	if cord ~= nil then
		return self.data[cord.x][cord.y].tile
	end
	return nil
end

function Grid:setTile(vec, tile, lerpSpeed) 
	local cord = self:validateCord(vec)
	if cord ~= nil then
		node = self.data[vec.x][vec.y]
		node.lerpSpeed = lerpSpeed
		node.tile = tile
	end
end

function Grid:getNode(vec) 
	local cord = self:validateCord(vec)
	if cord ~= nil then
		return self.data[cord.x][cord.y]
	end
	return nil
end

function Grid:validateCord(vec)
	if vec.x < 1 or vec.x > self.width or vec.y < 1 or vec.y > self.height then
		if self.wrap then
			if vec.x > self.width then
				vec.x = vec.x % self.width 
			elseif vec.x < 1 then
				vec.x = self.width + vec.x
			end
			if vec.y > self.height then
				vec.y = vec.y % self.height 
			elseif vec.y < 1 then
				vec.y = self.height + vec.y
			end
			return vec
		else
			return nil
		end
	else
		return vec
	end
end