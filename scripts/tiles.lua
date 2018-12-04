--TILE INFORMATION

--External scripts
require('scripts.object')
require('scripts.tilemap')

--Table to be populated with tile data
local P = {}

--Tile object template
P.tile = Object:new {
	name = "tile",
	lampCoords = {}
}
function P.tile:getImage()
end
function P.tile:onEnter()
end
function P.tile:blocksMovement()
end
function P.tile:onLoad()
end
function P.tile:addConnection()
end

--FLOOR TILE
P.floor = P.tile:new {
	name = "floor"
}
function P.floor:getImage()
	return util.getImage("graphics/darkfloor.png")
end
function P.floor:onEnter()
end
function P.floor:blocksMovement()
	return false
end
function P.floor:onLoad()
end

--WALL TILE
P.wall = P.tile:new {
	name = "wall"
}
function P.wall:getImage()
	return util.getImage("graphics/wfrontwall.png")
end
function P.wall:blocksMovement()
	return true
end

--LAMP TILE
P.lamp = P.tile:new {
	name = "lamp",
	state = "on"
}
function P.lamp:getImage()
	if self.state == "on" then
		return util.getImage("graphics/lamp.png")
	elseif self.state == "off" then
		return util.getImage("graphics/lampoff.png")
	end
end
function P.lamp:onEnter()
	if self.state == "on" then
		print("You are dead!")
	end
end
function P.lamp:toggleState()
	if self.state == "on" then
		self.state = "off"
	elseif self.state == "off" then
		self.state = "on"
	end
end

--DOOR TILE
P.door = P.tile:new {
	name = "door"
}
function P.door:getImage()
	return util.getImage("graphics/door.png")
end
function P.door:onEnter()
	curr = getTileCoord(player.xCoord, player.yCoord)
	dest = 0
	for i = 1, #currentMap.thisDoors do
		if(curr.x == currentMap.thisDoors[i].x) then
			print("Door " .. i .. " goes to " .. currentMap.thisDoors[i].goesTo)
			dest = currentMap.thisDoors[i].goesTo
		end
	end
	
	goToMap(dest)

end

--SWITCH TILE
P.switch = P.tile:new {
	name = "switch",
	state = "off",
	lampCoords = {}
}
function P.switch:getImage()
	if self.state == "off" then
		return util.getImage("graphics/leveroff.png")
	elseif self.state == "on" then
		return util.getImage("graphics/leveron.png")
	end
end
function P.switch:onEnter()
	self:toggleState()
end
function P.switch:toggleState()
	for i = 1, #self.lampCoords do
		tileMap[self.lampCoords[i][1]][self.lampCoords[i][2]]:toggleState()
	end

	if self.state == "on" then
		self.state = "off"
	elseif self.state == "off" then
		self.state = "on"
	end
end
function P.switch:addConnection(y, x)
	if #self.lampCoords == 0 then
		self.lampCoords = {}
	end
	
	table.insert(self.lampCoords, {y, x})
end

--STAIRCASE TILE
P.stairs = P.tile:new {
	name = "stairs"
}
function P.stairs:getImage()
	return util.getImage("graphics/tile.png")
end
function P.stairs:onEnter()
end

--TILE INDICES
P[0] = P.floor
P[1] = P.wall
P[2] = P.lamp
P[3] = P.door
P[4] = P.switch
P[5] = P.stairs

--Return tiles table
return P