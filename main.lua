require("data/data")
require("game/Game")
require("menu/MainMenu")
require("FontManager")
require("AudioManager")
require("HighscoreManager")


game = nil
mainMenu = nil

function love.load()
	-- ZeroBrane debugger
	if arg[#arg] == "-debug" then require("mobdebug").start() end
 	
 	-- Setup window
 	love.window.setMode(1280, 720);
 	love.window.setTitle("Lua Snakes")

 	-- Load Assets
 	FontManager.init()
 	AudioManager.init()
 	HighscoreManager.init()
 	
 	-- Init MainMenu
 	mainMenu = MainMenu()

 	gotoMenu()
end

function startGame(game)
	currentScene = game
end

function gotoMenu()
	currentScene = mainMenu
end

function gotoHighscore() 
	mainMenu:gotoHighscore()
	currentScene = mainMenu
end

function love.draw()
	currentScene:draw()
	-- love.graphics.setColor(255, 0, 0, 255)
	-- love.graphics.print("Snakes", 100, 100)
end

function love.update(dt)
	currentScene:update(dt)
end


grabbedText = ""
grabText = false
function startGrabbingText()
	grabText = true
	grabbedText = ""
end

function stopGrabbingText()
	grabText = false
	grabbedText = ""
end

function love.textinput(t)
	if grabText then
	    grabbedText = grabbedText .. t
	end
end