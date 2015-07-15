require("class")

HighscoreEntry = class(function(self, name, score)
	self.name = name
	self.score = score
end)

HighscoreManager = {}

function HighscoreManager.init()
	HighscoreManager.highscores = {}
	love.filesystem.setIdentity("Snakes")
	HighscoreManager.loadFromDisk() 
end

function HighscoreManager.addEntry(newEntry)
	local score = newEntry.score

	for i,entry in ipairs(HighscoreManager.highscores) do
		if entry.score < score then
			table.insert(HighscoreManager.highscores, i, newEntry)
			return 
		end
	end
	HighscoreManager.highscores[#HighscoreManager.highscores+1] = newEntry
end

function HighscoreManager.loadFromDisk() 
	data, size = love.filesystem.read("highscore.sav")
	local entrys = {}
	local sep = ","
	data:gsub("([^"..sep.."]*)"..sep, function(c) table.insert(entrys, c) end)

	for i=0,(#entrys/2)-1 do
		local j = (i*2)+1
		HighscoreManager.highscores[#HighscoreManager.highscores+1] = HighscoreEntry(entrys[j], tonumber(entrys[j+1]))
	end
	
	HighscoreManager.saveToDisk() 
end


function HighscoreManager.saveToDisk() 
	local data = ""

	for _,entry in ipairs(HighscoreManager.highscores) do
		data = data..entry.name..","..entry.score..","
	end
	love.filesystem.write( "highscore.sav", data )
end