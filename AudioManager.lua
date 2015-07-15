AudioManager = {}

function AudioManager.init()
	AudioManager.candy = love.audio.newSource("assets/sounds/candy.wav", "static")
	AudioManager.select_menu = love.audio.newSource("assets/sounds/select_menu.wav", "static")
	AudioManager.move_menu = love.audio.newSource("assets/sounds/move_menu.wav", "static")
	AudioManager.play_menu = love.audio.newSource("assets/sounds/play_menu.wav", "static")
	AudioManager.dead = love.audio.newSource("assets/sounds/dead.wav", "static")
	AudioManager.tick = love.audio.newSource("assets/sounds/tick.wav", "static")
	AudioManager.victory = love.audio.newSource("assets/sounds/victory.wav", "static")
end

function AudioManager.play(sound)
	love.audio.stop(sound)
	love.audio.play(sound)
end