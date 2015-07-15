require("class")
require("util")
require("FontManager")
require("AudioManager")

lastEnter = false 
lastBack = false 
lastUp = false
lastDown = false
lastRight = false
lastLeft = false 

Menu = class(function(self, buttonDelegate)
	self.buttons = {}
	self.buttonDelegate = buttonDelegate
	self.currentButton = nil;
	self.fadeTimer = 0.0
end)

function Menu:addButton(button)
	self.buttons[#self.buttons+1] = button
	if self.currentButton == nil then
	    self.currentButton = button
	end
	return button
end

function Menu:update(dt)
	self.fadeTimer = self.fadeTimer+dt

	local enter = love.keyboard.isDown("return") or love.keyboard.isDown(" ")
	local back = love.keyboard.isDown("backspace") or love.keyboard.isDown("escape")
	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")
	local right = love.keyboard.isDown("right")
	local left = love.keyboard.isDown("left")

	if back and not lastBack then
	    self.buttonDelegate:onBack()
	end

	if enter and not lastEnter then
		if not self.currentButton:onPress() then
		    self.buttonDelegate:onButton(self.currentButton)
		end
	end

	if #self.buttons > 1 then
		if up and not lastUp then
		    local prev = (util.table.indexOf(self.buttons, self.currentButton) - 1)
		    if prev <= 0 then prev = #self.buttons end
		    self.currentButton = self.buttons[prev]
		    AudioManager.play(AudioManager.move_menu)
		end
		
		if down and not lastDown then
		    local nex = (util.table.indexOf(self.buttons, self.currentButton) + 1) % #self.buttons
		    if nex == 0 then nex = #self.buttons end
		    self.currentButton = self.buttons[nex]
		    AudioManager.play(AudioManager.move_menu)
		end
	end

	if left and not lastLeft then
		self.currentButton:prevOption()
	end

	if right and not lastRight then
		self.currentButton:nextOption()
	end

	lastEnter = enter
	lastUp = up
	lastDown = down
	lastBack = back 
	lastRight = right
	lastLeft = left 
end

function Menu:draw()
	local sw = love.graphics.getWidth()
	local sh = love.graphics.getHeight()
	local centerX = sw*.5

	-- draw the current menu
	FontManager.set(FontManager.smallFont)
	local yCur = sh*.4
	for _,button in ipairs(self.buttons) do
		yCur = yCur + FontManager.currentFont.size + 5
		if button == self.currentButton then
			local width = 500
			local mul = 0.1 + ((1.0+math.sin(self.fadeTimer*2.0))*.5)*.5
			love.graphics.setColor(255, 255, 255, 255*mul)
		    love.graphics.rectangle("fill", centerX-width*.5, yCur-4, width, FontManager.currentFont.size)
		end

		Color.set(button.color)
		FontManager.printCenter(button.title, centerX, yCur)
	end
end