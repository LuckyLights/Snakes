require("class")
require("data/Color")


Tile = class(function(self, type, color)
	self.type = type
	self.color = color
end)

-- Tile types enum
TileType = {}
TileType.EMPTY, TileType.SNAKE, TileType.CANDY = 1, 2, 3

--Pre defiend tiles
EmptyTile = Tile(TileType.EMPTY, Color(50, 50, 50, 255))

-- Candy type
CandyType = {}
CandyType.NORMAL, CandyType.DEATH, CandyType.FAT = 1, 2, 3