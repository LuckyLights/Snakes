require("class")
require("menu/Menu")
require("menu/Button")
require("menu/HighscoreMenu")

require("game/Snake")

require("AudioManager")

-- Parameters for the button options
Speed = {}
Speed.normal, Speed.fast, Speed.faster, Speed.insane, Speed.slow, Speed.snail = "Speed: Normal", "Speed: Fast", "Speed: Faster", "Speed: Insane!!!", "Speed: Slow", "Speed: Snail"
GameSpeed = {}
GameSpeed[Speed.normal] = 0.1
GameSpeed[Speed.fast] = 0.05
GameSpeed[Speed.faster] = 0.025
GameSpeed[Speed.insane] = 0.001
GameSpeed[Speed.slow] = 0.15
GameSpeed[Speed.snail] = 0.3

Warp = {}
Warp.on, Warp.off = "Wrap: ON", "Wrap: OFF"

PlayerOptions = {SnakeType.PLAYER, SnakeType.AI, nil}

MainMenu = class(function(self)

	-- Init all buttons and menus
	self.startMenu = Menu(self)
	self.startMenu:addButton(Button({"Press Start"}))

	self.mainMenu = Menu(self)
	self.mainMenu:addButton(Button({"Solo Snake"}))
	self.mainMenu:addButton(Button({"Multiplayer Snake"}))
	self.mainMenu:addButton(Button({"Lightbikes"}))
	self.mainMenu:addButton(Button({"Highscore"}))
	self.mainMenu:addButton(Button({"Quit"}))

	self.playButton = Button({"Play"});

	self.warpButton = Button({Warp.on, Warp.off})
	self.speedButton = Button({Speed.normal, Speed.fast, Speed.faster, Speed.insane, Speed.slow, Speed.snail})
	self.p1Button = Button({"P1: Player", "P1: AI"})
	self.p2Button = Button({"P2: Player", "P2: AI"})
	self.p3Button = Button({"P3: Player", "P3: AI", "P3: OFF"})
	self.p4Button = Button({"P4: Player", "P4: AI", "P3: OFF"})

	self.p1Button.color = SnakeColors[1]:clone()
	self.p2Button.color = SnakeColors[2]:clone()
	self.p3Button.color = SnakeColors[3]:clone()
	self.p4Button.color = SnakeColors[4]:clone()
	self.p1Button.color.a, self.p2Button.color.a, self.p3Button.color.a, self.p4Button.color.a = 255, 255, 255, 255 

	self.p2Button:setOptionIndex(2)
	self.p3Button:setOptionIndex(2)
	self.p4Button:setOptionIndex(2)

	self.soloMenu = Menu(self)
	self.soloMenu:addButton(self.playButton)
	self.soloMenu:addButton(self.warpButton)
	self.soloSpeed = self.soloMenu:addButton(self.speedButton)

	self.multiMenu = Menu(self)
	self.multiMenu:addButton(self.playButton)
	self.multiMenu:addButton(self.p1Button)
	self.multiMenu:addButton(self.p2Button)
	self.multiMenu:addButton(self.p3Button)
	self.multiMenu:addButton(self.p4Button)
	self.multiMenu:addButton(self.warpButton)
	self.multiMenu:addButton(self.speedButton)

	self.lightbikeMenu = Menu(self)
	self.lightbikeMenu:addButton(self.playButton)
	self.lightbikeMenu:addButton(self.p1Button)
	self.lightbikeMenu:addButton(self.p2Button)
	self.lightbikeMenu:addButton(self.p3Button)
	self.lightbikeMenu:addButton(self.p4Button)
	self.lightbikeMenu:addButton(self.warpButton)
	self.lightbikeMenu:addButton(self.speedButton)

	self.highscoreMenu = HighscoreMenu(self)

	-- init the background game 
	self.backgroundGame = Game(GameMode.MULTI_SNAKE, GameSpeed[Speed.fast], SnakeType.AI, SnakeType.AI, SnakeType.AI, SnakeType.AI, false, true)

	-- start at the start menu
	self.currentMenu = self.startMenu
end)

function MainMenu:onButton(button)
	if button.title == "Press Start" then
	    self.currentMenu = self.mainMenu
	    AudioManager.play(AudioManager.select_menu)
	elseif button.title == "Solo Snake" then
	    self.currentMenu = self.soloMenu
	    AudioManager.play(AudioManager.select_menu)
	elseif button.title == "Multiplayer Snake" then
	    self.currentMenu = self.multiMenu
	    AudioManager.play(AudioManager.select_menu)
	elseif button.title == "Lightbikes" then
	    self.currentMenu = self.lightbikeMenu
	    AudioManager.play(AudioManager.select_menu)
	elseif button.title == "Highscore" then
	    self.currentMenu = self.highscoreMenu
	    AudioManager.play(AudioManager.select_menu)
	elseif button.title == "Quit" then
	    love.event.push("quit")
	elseif button == self.playButton then
		if self.currentMenu == self.soloMenu then
			local game = Game(GameMode.SNAKE, GameSpeed[self.soloSpeed.title], SnakeType.PLAYER, nil, nil, nil, self.warpButton.title == Warp.on, false)
			startGame(game)
		elseif self.currentMenu == self.multiMenu then
			local game = Game(GameMode.MULTI_SNAKE, GameSpeed[self.soloSpeed.title], PlayerOptions[self.p1Button:getOptionIndex()], PlayerOptions[self.p2Button:getOptionIndex()], PlayerOptions[self.p3Button:getOptionIndex()], PlayerOptions[self.p4Button:getOptionIndex()], self.warpButton.title == Warp.on, false)
			startGame(game)
		elseif self.currentMenu == self.lightbikeMenu then
			local game = Game(GameMode.LIGHT_BIKES, GameSpeed[self.soloSpeed.title], PlayerOptions[self.p1Button:getOptionIndex()], PlayerOptions[self.p2Button:getOptionIndex()], PlayerOptions[self.p3Button:getOptionIndex()], PlayerOptions[self.p4Button:getOptionIndex()], self.warpButton.title == Warp.on, false)
			startGame(game)
		end
		AudioManager.play(AudioManager.play_menu)
	end
end

function MainMenu:onBack()
	if self.currentMenu == self.mainMenu then
	    self.currentMenu = self.startMenu
	elseif self.currentMenu == self.startMenu then
	    love.event.push("quit")
	else
		self.currentMenu = self.mainMenu
	end
end

function MainMenu:update(dt)
	self.backgroundGame:update(dt)
	self.currentMenu:update(dt)
end

function MainMenu:draw()
	self.backgroundGame:draw()

	-- draw title
	if self.currentMenu ~= self.highscoreMenu then
		local sw = love.graphics.getWidth()
		local sh = love.graphics.getHeight()

		love.graphics.setColor(255, 255, 255, 255)
		FontManager.set(FontManager.bigFont)
		FontManager.printCenter("Snakes", sw*.5, sh*.2)
	end

	-- darw the current menu
	self.currentMenu:draw()
end

function MainMenu:gotoHighscore() 
	self.currentMenu = self.highscoreMenu
end