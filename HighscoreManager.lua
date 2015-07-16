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

	-- no need for complicated sorting here just find the score location and insert it
	for i,entry in ipairs(HighscoreManager.highscores) do
		if entry.score < score then
			table.insert(HighscoreManager.highscores, i, newEntry)
			HighscoreManager.saveToDisk()
			return 
		end
	end
	-- incase where the biggest score
	HighscoreManager.highscores[#HighscoreManager.highscores+1] = newEntry
	HighscoreManager.saveToDisk()
end

function HighscoreManager.loadFromDisk() 
	local data, size = love.filesystem.read("highscore.sav")
	local entrys = {}
	local sep = ","
	-- some string slipt functionIi found on lua-users.org 
	data:gsub("([^"..sep.."]*)"..sep, function(c) table.insert(entrys, c) end)

	-- takes every to elemets and add them togeter as an highscore entry
	for i=0,(#entrys/2)-1 do
		local j = (i*2)+1
		HighscoreManager.highscores[#HighscoreManager.highscores+1] = HighscoreEntry(entrys[j], tonumber(entrys[j+1]))
	end
end


function HighscoreManager.saveToDisk() 
	local data = ""
	-- build comma seprated list of the highscores
	for _,entry in ipairs(HighscoreManager.highscores) do
		data = data..entry.name..","..entry.score..","
	end
	love.filesystem.write( "highscore.sav", data )
end