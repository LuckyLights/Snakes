util = {}
util.table = {}

--uses _ to avoid namespace collision

function util.table.indexOf(_table, _value)
	for i,v in ipairs(_table) do
		if v == _value then
			return i
		end 
	end
end

function util.table.removeValue(_table, _value)
	table.remove(_table, util.table.indexOf(_table, _value))
end

function util.table.contains(_table, _value)
	for i,v in ipairs(_table) do
		if v == _value then
			return true
		end 
	end
	return false
end