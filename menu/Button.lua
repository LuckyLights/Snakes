require("class")
require("data/Color")
Button = class(function(self, options)
	self.options = options
	self.title = options[1]
	self.color = Color(255, 255, 255, 255)
end)


function Button:update()
	
end

function Button:onPress()
	if #self.options == 1 then
	    return false
	end 

	self:nextOption()
end

function Button:nextOption()
	local nex = (util.table.indexOf(self.options, self.title) + 1) % #self.options
	if nex == 0 then nex = #self.options end
	self.title = self.options[nex]
end

function Button:prevOption()
	local prev = (util.table.indexOf(self.options, self.title) - 1)
	if prev <= 0 then prev = #self.options end
	self.title = self.options[prev]
end

function Button:setOptionIndex(i)
	self.title = self.options[i]
end

function Button:getOptionIndex()
	return util.table.indexOf(self.options, self.title)
end