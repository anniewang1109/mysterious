require('scripts.object')

local P = {}

P.tile = Object:new{
}
function P.tile:getImage()
	return util.getImage("graphics/woodfloor.png")
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
	return util.getImage("graphics/lampTest.png")
end

P[0] = P.blankTile
P[1] = P.wall
P[2] = P.lamp

return P