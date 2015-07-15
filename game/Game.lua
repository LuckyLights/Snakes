require("class")
require("util")

require("game/Tile")
require("game/Snake")
require("game/Grid")

require("AudioManager")

-- GameMode enum
GameMode = {SNAKE = 1, MULTI_SNAKE = 2, LIGHT_BIKES = 3}
GameState = {INTRO = 1, RUNNING = 2, OUTRO = 3}
SnakeStartingDirs = {Vec2.DOWN, Vec2.UP, Vec2.RIGHT, Vec2.LEFT}
ScoreCords = {Vec2(0.1, 0.1), Vec2(0.8, 0.1), Vec2(0.1, 0.5), Vec2(0.8, 0.5)}

Game = class(function(self, gameMode, gameSpeed, p1, p2, p3, p4, wrap, demo)
	self.gameMode = gameMode
	self.gameSpeed = gameSpeed
	self.demo = demo

	self.p1 = p1;
	self.p2 = p2;
	self.p3 = p3;
	self.p4 = p4;

	self.warp = warp;

	self:reset()

end)

function Game:reset()
	self.snakes = {}

	if self.gameMode ~= GameMode.LIGHT_BIKES then
	    self.grid = Grid(32, 32, self.wrap)
		if self.p1 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(self.grid.width/2, 0), SnakeStartingDirs[1], self.p1, 1) 
		end
		if self.p2 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(self.grid.width/2, self.grid.height+1), SnakeStartingDirs[2], self.p2, 2) 
		end
		if self.p3 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(0, self.grid.height/2), SnakeStartingDirs[3], self.p3, 3) 
		end
		if self.p4 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(self.grid.width+1, self.grid.height/2), SnakeStartingDirs[4], self.p4, 4) 
		end
	else
		self.grid = Grid(64, 64, self.wrap)
		local offset = 12
		if self.p1 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(offset, offset), SnakeStartingDirs[1], self.p1, 1) 
		end
		if self.p2 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(self.grid.width-offset, self.grid.height-offset), SnakeStartingDirs[2], self.p2, 2) 
		end
		if self.p3 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(offset, self.grid.height-offset), SnakeStartingDirs[3], self.p3, 3) 
		end
		if self.p4 ~= nil then
		   	self.snakes[#self.snakes+1] = Snake(Vec2(self.grid.width-offset, offset), SnakeStartingDirs[4], self.p4, 4) 
		end
	end

	self.candyNodes = {}

	self.framesCount = 0
	self.candyTimer = 0.0
	self.frameTimer = 0.0

	self.readyTimer = 0.0
	self.readyTimerBleep = 0.0

	self.endTimer = 0.0

	if self.demo then
	    self.state = GameState.RUNNING;
	else
		-- lets step the game 3 steps forward so we have soming to look at durring count down
		self:gameStep()
		self:gameStep()
		self:gameStep()

		self.state = GameState.INTRO;
	end
end

function Game:draw()

	-- render game grid
	local sw = love.graphics.getWidth()
	local sh = love.graphics.getHeight()

	local screenBoarder = 22;
	local tileSize = math.abs((math.min(sw, sh)-screenBoarder) / self.grid.width)
	local boarder = 2

	local totalWidth = tileSize * self.grid.width;
	local totalHeight = tileSize * self.grid.height;

	local sx = (sw * .5 - totalWidth * .5) - tileSize
	local sy = (sh * .5 - totalHeight * .5) - tileSize

	for x=1,self.grid.width do
		for y=1,self.grid.height do
			node = self.grid:getNode({x=x,y=y})
			node.color = Color.lerp(node.color, node.tile.color, node.lerpSpeed)

			local mul = 1.0
			if self.demo then
			    mul = 0.5
			end

			love.graphics.setColor(node.color.r*mul, node.color.g*mul, node.color.b*mul, node.color.a)
			love.graphics.rectangle("fill", sx+tileSize*x, sy+tileSize*y, tileSize-boarder, tileSize-boarder)
		end
	end

	if self.demo == false and self.gameMode ~= GameMode.LIGHT_BIKES then
	   	-- render score boards
		FontManager.set(FontManager.smallFont)
		for i,snake in ipairs(self.snakes) do
			local num =  snake.number
			local color = SnakeColors[num]
			local mul = 1.2
			if snake.dead then
			    mul = 0.5
			end
			love.graphics.setColor(color.r*mul, color.g*mul, color.b*mul, 255)
			love.graphics.print("P"..i..": "..(snake.length-4), ScoreCords[num].x*sw, ScoreCords[num].y*sh)
		end
	end

	if self.state == GameState.INTRO then
		-- render intro countdown
		love.graphics.setColor(255, 255, 255, 255)
		FontManager.set(FontManager.bigFont)

		FontManager.printCenter(3-self.readyTimerBleep, sw*.5, sh*.4)				

	elseif self.state == GameState.OUTRO then
		
		-- render outro display
		if self.endTimer >= 1.5 then
		    if self.gameMode == GameMode.SNAKE then
				love.graphics.setColor(255, 255, 255, 255)
				FontManager.set(FontManager.bigFont)

				FontManager.printCenter("Score: "..(self.snakes[1].length-4), sw*.5, sh*.4)
				FontManager.set(FontManager.smallFont)
				FontManager.printCenter("Endter Name: "..string.sub(grabbedText, 1, 3), sw*.5, sh*.6)
			else
				if self.winner ~= nil then
					local color = SnakeColors[self.winner.number]
					local mul = 1.2
					love.graphics.setColor(color.r*mul, color.g*mul, color.b*mul, 255)
					
					FontManager.set(FontManager.bigFont)
					FontManager.printCenter("P"..self.winner.number.." WINS!", sw*.5, sh*.4)

				else
					love.graphics.setColor(255, 255, 255, 255)
					FontManager.set(FontManager.bigFont)
					FontManager.printCenter("Draw", sw*.5, sh*.4)	
				end	
			end
		end
	end
end

function Game:update(dt)
	if love.keyboard.isDown("escape") then
	    gotoMenu()
	end

	if self.state == GameState.INTRO then
		self:updateIntro(dt)
	elseif self.state == GameState.RUNNING then
		self:updateGame(dt)
	elseif self.state == GameState.OUTRO then
		self:updateOutro(dt)
	end
end

function Game:updateIntro(dt) 
	self.readyTimer = self.readyTimer + dt;
	local preBeep = self.readyTimerBleep
	self.readyTimerBleep = math.floor(self.readyTimer)

	if preBeep ~= self.readyTimerBleep then
		if self.readyTimerBleep == 3 then
			AudioManager.play(AudioManager.play_menu)
		else
		    AudioManager.play(AudioManager.tick)
		end 
	end

	if self.readyTimer >= 3 then
		self.state = GameState.RUNNING;
	end
end

function Game:updateOutro(dt)
	self.endTimer = self.endTimer + dt

	if self.endTimer >= 1.5 and not self.playedVictory then
		self.playedVictory = true
		AudioManager.play(AudioManager.victory)
	end

	if self.gameMode ~= GameMode.SNAKE then
		if self.endTimer >= 5 or love.keyboard.isDown("return") then
			gotoMenu()
		end
	else
		if self.endTimer >= 1.5 and love.keyboard.isDown("return") then
			if #grabbedText >= 3 then
				HighscoreManager.addEntry(HighscoreEntry(string.sub(grabbedText, 1, 3), (self.snakes[1].length-4)))
			else
				HighscoreManager.addEntry(HighscoreEntry("XXX", (self.snakes[1].length-4)))
			end
			stopGrabbingText()
			gotoHighscore()
		end
	end
end


function Game:updateGame(dt)

	-- capture input every frame so we dont miss any in between turns
	for i, snake in ipairs(self.snakes) do
		snake:captureInput()
	end

	-- update timers
	self.framesCount = self.framesCount + 1;
	self.candyTimer = self.candyTimer+dt;
	self.frameTimer = self.frameTimer+dt;

	-- Turn updates every so many frames set by game speed
	if self.frameTimer > self.gameSpeed then
		self.frameTimer = 0.0

		-- okay lets take a step
		self:gameStep()
	end
end

function Game:gameStep(dt)
	-- First lets everyone decide what to do next simultaneously
	-- Possible multithreding optimization
	for i, snake in ipairs(self.snakes) do
		snake:updateLogic(self.grid, self.snakes, self.candyNodes, self.gameMode)
	end

	-- Update some global rules like adding candy
	if self.gameMode ~= GameMode.LIGHT_BIKES then
		if self.candyTimer > 1.0 and #self.candyNodes < 5 then

			self.candyTimer = 0
			local tryCount = 0
			repeat
				local cord = Vec2(love.math.random(1, self.grid.width), love.math.random(1, self.grid.height))
				if self.grid:getTile(cord) == EmptyTile then
					self.grid:setTile(cord, CandyTile, 0.2)
					self.candyNodes[#self.candyNodes+1] = self.grid:getNode(cord)

					tryCount = 11
				else 
					tryCount = tryCount + 1
				end 
			until tryCount > 10
		end
	end

	-- Move all snakes accrouding to directions
	-- By ordering it this way the AI can 'cheat'
	-- sense it dosent know anything the player dosent
	local deadSnakes = {}
	for _, snake in ipairs(self.snakes) do
		if snake.dead ~= true then
			local move = snake.pos + snake.direction

			--check world bounds
			move = self.grid:validateCord(move)
			if move == nil then
				deadSnakes[#deadSnakes+1] = snake
			else
				local node = self.grid:getNode(move)
				if node.tile.type == TileType.SNAKE then
					deadSnakes[#deadSnakes+1] = snake
				else
					snake.buffer[snake.step] = move:clone();
					snake.step = (snake.step % snake.length) + 1

					if self.gameMode ~= GameMode.LIGHT_BIKES then
	   					-- find last entry
						local j = snake.step - snake.length
						if j < 1 then j = snake.length+j end
						local cord = snake.buffer[j]

						if cord ~= nil then
							self.grid:setTile(cord, EmptyTile, 1)
						end

						if node.tile == CandyTile then
							snake.length = snake.length + 1
							util.table.removeValue(self.candyNodes, node)
							if not self.demo then AudioManager.play(AudioManager.candy) end
						end

					elseif self.gameMode == GameMode.LIGHT_BIKES then
						snake.length = snake.length + 1
					end

					node.tile = snake.tile
					node.lerpSpeed = 1
					snake.pos:set(move)
				end
			end
		end
	end

	-- kill snakes later for fair play
	-- again this is so you have no frame order advantages
	for _, snake in ipairs(deadSnakes) do
		self:killSnake(snake)
	end

	-- check wining/loseing conditions
	local aliveSnakes = 0
	local snakeAlive = nil
	for _, snake in ipairs(self.snakes) do
		if not snake.dead then
			aliveSnakes = aliveSnakes + 1
			snakeAlive = snake
		end
	end

	if self.gameMode == GameMode.SNAKE then
		if aliveSnakes <= 0 then
			self.state = GameState.OUTRO

			-- tells main we want to grab text for the player name
			startGrabbingText()
		end
	else
		if aliveSnakes <= 1 then
			if self.demo then
				self:reset()
			else
				self.state = GameState.OUTRO
				self.winner = snakeAlive
			end
		end
	end
end

function Game:killSnake(snake)
	snake:die()
	if not self.demo then
	    AudioManager.play(AudioManager.dead)
	end
	for i,cord in ipairs(snake.buffer) do
		self.grid:setTile(cord, EmptyTile, 0.05)
	end
end