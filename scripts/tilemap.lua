--TILEMAP FUNCTIONS

function isMovableTile(type)
	if type == 1 then
		return false
	else
		return true
	end
end

--Returns x, y in terms of tiles instead of pixels
function getTileCoord(x, y)
	tempX = math.floor(x/tileWidth)
	tempY = math.floor(y/tileHeight)

	return {x=tempX, y=tempY}
end

--Determine whether a player can move to the location tile
function canMoveTo(locX, locY)
	for i = 1, #player.hitbox do
		local hitboxPoint = player.hitbox[i]
		local thisX = locX + hitboxPoint[1]
		local thisY = locY + hitboxPoint[2]

		local tc = getTileCoord(thisX, thisY)

		if (tc.x <= 0 or tc.x > 10 or tc.y <= 0 or tc.y > 10) then
			--return false
		else
			local tile = tileMap[tc.y][tc.x]
			
			if (tile:blocksMovement()) then
				return false
			end
		end
	end

	return true
end

--Given map table, create a functional tileMap from each id,
--and assign the values to tiles from tile script
function createTileMap(map)
	local ret = {}
	for i = 1, #map do
		ret[i] = {}
		for j = 1, #map[i] do
			local index = map[i][j]
			ret[i][j] = tiles[index]:new()
		end
	end

	return ret
end

--Allow map switching
function goToMap(index)
	print(index)
	currentMap = maps[index]
	tileMap = createTileMap(currentMap.thisMap)--Initial tileMap


	--Associate switches to lamps through connection data in level
	if currentMap.thisConnections ~= nil then
		for i = 1, #currentMap.thisConnections do
			local connections = currentMap.thisConnections[i]
			local tile = tileMap[connections[1]][connections[2]]
			tile:addConnection(connections[3], connections[4])
		end
	end
end