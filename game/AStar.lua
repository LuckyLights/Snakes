require("util")

AStar = {}

-- kind of std AStar
function AStar.findPath(start, goal, grid, dir)

	if start == goal then
		return nil
	end

	local openNodes = {start}
	local closedNodes = {}
	local cameFromNodes = {}
	local distances = {}

	cameFromNodes[start] = {node = nil, dir = dir}
	distances[start] = (goal.pos-start.pos):sqrMagnitude()

	while #openNodes > 0 do

		local currentDistance = math.huge
		local inx = 0
		for i,node in ipairs(openNodes) do
			if distances[node] < currentDistance then
				currentDistance = distances[node]
				inx = i
			end
		end

		local current = table.remove(openNodes, inx)
		closedNodes[current] = current

		if current == goal or currentDistance == 0 then
			return AStar.backtrackPath(current, start, cameFromNodes)
		end

		local neighbors = AStar.getNeighboringNodes(current, grid, cameFromNodes[current].dir:inverse())
		for _,neighbor in ipairs(neighbors) do
			if closedNodes[neighbor.node] == nil then
				if not util.table.contains(openNodes, neighbor.node) then
					distances[neighbor.node] = currentDistance + (goal.pos-neighbor.node.pos):sqrMagnitude()
					cameFromNodes[neighbor.node] = {node=current, dir=neighbor.dir}
					openNodes[#openNodes+1] = neighbor.node
				end
			end
		end
	end
	return nil
end

function AStar.backtrackPath(node, goal, cameFromNodes)
	local cameFrom = cameFromNodes[node]

	if cameFrom.node == goal then
		return cameFrom.dir
	else 
		return AStar.backtrackPath(cameFrom.node, goal, cameFromNodes)
	end
end

function AStar.getNeighboringNodes(node, grid, ignoreDir)
	local neighbors = {}
	AStar.getNode(node.pos, Vec2.UP, grid, neighbors, ignoreDir)
	AStar.getNode(node.pos, Vec2.DOWN, grid, neighbors, ignoreDir)
	AStar.getNode(node.pos, Vec2.LEFT, grid, neighbors, ignoreDir)
	AStar.getNode(node.pos, Vec2.RIGHT, grid, neighbors, ignoreDir)
	return neighbors
end

function AStar.getNode(pos, dir, grid, neighbors, ignoreDir)
	if dir == ignoreDir then
		return
	end

	local cord = grid:validateCord(pos+dir)
	if cord ~= nil then
		node = grid:getNode(cord)
		if node.tile.type ~= TileType.SNAKE then
		    neighbors[#neighbors+1] = {node=node, dir=dir}
		end
	end
end