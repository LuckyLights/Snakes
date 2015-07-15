KeyboardManager = {}

KeyboardManager.lastEnter = false 
KeyboardManager.lastBack = false 
KeyboardManager.lastUp = false
KeyboardManager.lastDown = false
KeyboardManager.lastRight = false
KeyboardManager.lastLeft = false 

function KeyboardManager.update()
	local enter = love.keyboard.isDown("return") or love.keyboard.isDown(" ")
	local back = love.keyboard.isDown("backspace") or love.keyboard.isDown("escape")
	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")
	local right = love.keyboard.isDown("right")
	local left = love.keyboard.isDown("left")


	KeyboardManager.enter = enter and not KeyboardManager.lastEnter
	KeyboardManager.up = up and not KeyboardManager.lastUp
	KeyboardManager.down = down and not KeyboardManager.lastDown
	KeyboardManager.back = back and not KeyboardManager.lastBack
	KeyboardManager.right = right and not KeyboardManager.lastRight
	KeyboardManager.left = left and not KeyboardManager.lastLeft


	KeyboardManager.lastEnter = enter
	KeyboardManager.lastUp = up
	KeyboardManager.lastDown = down
	KeyboardManager.lastBack = back 
	KeyboardManager.lastRight = right
	KeyboardManager.lastLeft = left 
end