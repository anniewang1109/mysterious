require('scripts.object')

local P = {}

P.tile = Object:new{
}
function P.tile:getImage()
	return util.getImage("graphics/woodfloor.png")
end
function P.tile:onEnter()
end 

P.blankTile = P.tile:new {}

P.wall = P.tile:new {
}
function P.wall:getImage()
	return util.getImage("graphics/wfrontwall.png")
end

P.lamp = P.tile:new {
}
function P.lamp:getImage()
	return util.getImage("graphics/lamp.png")
end
function P.lamp:onEnter()
	print ("on lamp!")
end

P.door = P.tile:new {
}
function P.door:getImage()
	return util.getImage("graphics/door.png")
end

P[0] = P.blankTile
P[1] = P.wall
P[2] = P.lamp
P[3] = P.door

return P
