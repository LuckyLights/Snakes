require("class")
require("HighscoreManager")
 
lastBack = false 

HighscoreMenu = class(function(self, buttonDelegate)
	self.buttonDelegate = buttonDelegate
	self.currentButton = nil
	self.fadeTimer = 0.0
end)

function HighscoreMenu:update(dt)
	self.fadeTimer = self.fadeTimer+dt

	local back = love.keyboard.isDown("backspace") or love.keyboard.isDown("escape")

	if back and not lastBack then
	    self.buttonDelegate:onBack()
	end

	lastBack = back 
end

function HighscoreMenu:draw()
	local sw = love.graphics.getWidth()
	local sh = love.graphics.getHeight()
	local numCol = sw*.4
	local firstCol = numCol+sw*.05
	local secCol = firstCol+sw*.1

	-- draw the current menu
	FontManager.set(FontManager.smallFont)
	local yCur = sh*.03
	for i=1,15 do
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(i, numCol, yCur)
		local entry = HighscoreManager.highscores[i]

		if entry ~= nil then
			love.graphics.print(entry.name..":", firstCol, yCur)
			love.graphics.print(entry.score, secCol, yCur)
		else
			love.graphics.print("---", firstCol, yCur)
			love.graphics.print("---", secCol, yCur)
		end
		yCur = yCur + FontManager.currentFont.size + 5
	end
end