require('scripts.object')

local P = {}
tiles = P

P.tile = Object:new{
}
function P.tile:getImage()
	return ""
end



tiles[1] = P.tile
