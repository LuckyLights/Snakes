require("class")
require("game/Tile")
require("game/AStar")

-- Snake Type
SnakeType = {}
SnakeType.PLAYER, SnakeType.AI = 1, 2

-- Snake Controllers
Controlls = {}
Controlls[1] = {up = "up", down = "down", left = "left", right = "right"}
Controlls[2] = {up = "w", down = "s", left = "a", right = "d"}
Controlls[3] = {up = "t", down = "g", left = "f", right = "h"}
Controlls[4] = {up = "i", down = "k", left = "j", right = "l"}

-- Snake Colors
SnakeColors = {Color(0, 0, 190, 255), Color(150, 0, 0, 255), Color(0, 150, 0, 255), Color(150, 150, 0, 255)}

-- Snake

Snake = class(function(self, pos, dir, type, number)
	self.pos = pos
	self.type = type
	self.number = number
	
	self.tile = Tile(TileType.SNAKE, SnakeColors[number])
	self.tile.snake = self

	self.dead = false

	self.direction = dir

	self.buffer = {}
	self.length = 4
	self.step = 1

	self.inputCapture = {up = false, down = false, left = false, right = false}
end)


function Snake:captureInput()
	if self.type == SnakeType.PLAYER then
		self:captureKey("up")
		self:captureKey("down")
		self:captureKey("left")
		self:captureKey("right")
	end 
end

function Snake:captureKey(key)
	if love.keyboard.isDown(Controlls[self.number][key]) then self.inputCapture[key] = true end
end

function Snake:updateLogic(grid, snakes, candyNodes, gameMode)
	if self.type == SnakeType.PLAYER then
	    self:updateLogicPlayer()
	else 
		if gameMode ~= GameMode.LIGHT_BIKES then
			self:updateSnakeLogicAI(grid, candyNodes)
		else
			self:updateLightbikeLogicAI(grid, snakes)
		end
	end

end

function Snake:updateLogicPlayer()
	local up = self.inputCapture.up
	local down = self.inputCapture.down
	local left = self.inputCapture.left
	local right = self.inputCapture.right

	if self.direction.y == 0 then
		if up then
			self.direction = Vec2.UP
		elseif down then
			self.direction = Vec2.DOWN
		end
	else 
		if left then
			self.direction = Vec2.LEFT
		elseif right then
			self.direction = Vec2.RIGHT
		end
	end

	self.inputCapture.up = false
	self.inputCapture.down = false
	self.inputCapture.left = false
	self.inputCapture.right = false
end

function Snake:updateSnakeLogicAI(grid, candyNodes) 
	
	-- find the closes 'piece of candy' ... LOL!
	local closesDistance = math.huge
	local closesCandyNode = nil
	for _,candyNode in ipairs(candyNodes) do
		if candyNode.tile.candyType ~= CandyType.DEATH then
		   	local diff = self.pos - candyNode.pos
			local dist = diff:sqrMagnitude()
			if dist < closesDistance then
				closesDistance = dist
				closesCandyNode = candyNode
			end
		end
	end

	if closesCandyNode ~= nil then
		local tempDir = AStar.findPath(grid:getNode(self.pos), closesCandyNode, grid, self.direction)
		if tempDir ~= nil then
		    self.direction = tempDir
		else 
			self:primitiveAIUpdate(grid)
		end
	else
		self:primitiveAIUpdate(grid)
	end
end

function Snake:updateLightbikeLogicAI(grid, snakes) 
	-- this AI is bad...
	-- find the closes snake head + next move
	local closesDistance = math.huge
	local closesNode = nil
	for _,snake in ipairs(snakes) do
		if snake ~= self then
			local tempPos = snake.pos + snake.direction
			local tempNode = grid:getNode(tempPos)

			if tempNode ~= nil and tempNode.tile.type ~= TileType.SNAKE then

			    local diff = self.pos - tempPos
				local dist = diff:sqrMagnitude()
				if dist < closesDistance then
					closesDistance = dist
					closesNode = tempNode
				end

			end
		end
	end

	if closesNode ~= nil then
		local tempDir = AStar.findPath(grid:getNode(self.pos), closesNode, grid, self.direction)
		if tempDir ~= nil then
		    self.direction = tempDir
		else
			self:primitiveAIUpdate(grid)
		end
	else
		self:primitiveAIUpdate(grid)
	end
end

function Snake:primitiveAIUpdate(grid)
	-- path finding failed, we cant get to our target, "just try to survive" AI kicks in
	local tile = grid:getTile(self.pos+self.direction)
	if tile == nil or tile.type == TileType.SNAKE then
		-- the tile infornt of the snake is a snake try to turn 
		local tile = grid:getTile(self.pos+self.direction:fliped())
		if tile == nil or tile.type == TileType.SNAKE then 
			-- that way is blocked to try the other way
			local tile = grid:getTile(self.pos+self.direction:fliped():inverse())
			if tile == nil or tile.type == TileType.SNAKE then 
				-- accept certain death and do nothing
			else
				self.direction = self.direction:fliped():inverse()
			end
		else
			self.direction = self.direction:fliped()
		end
	end
end

function Snake:die()
	self.dead = true
end