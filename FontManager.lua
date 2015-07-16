FontManager = {}

function FontManager.init() 
	FontManager.bigFont = {font=love.graphics.newFont("assets/fonts/font.ttf", 120), size=120}
	FontManager.smallFont = {font=love.graphics.newFont("assets/fonts/font.ttf", 40), size=40}
end

function FontManager.set(font)
	FontManager.currentFont = font
	love.graphics.setFont(font.font)
end

function FontManager.printCenter(string, x, y)
	love.graphics.print(string, x-FontManager.currentFont.font:getWidth(string)*.5, y)
end