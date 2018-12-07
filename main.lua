--Make graphics look better
love.graphics.setDefaultFilter( "nearest" )
io.stdout:setvbuf("no")

--External scripts
util = require("scripts.util")
tiles = require("scripts.tiles")
require("scripts.tilemap")

function love.load()
	tileWidth = 50
	tileHeight = 50

	--Shader functions
	createShader()
	love.graphics.setShader(myShader)

	--Player sprite and data
	playerSprite = util.getImage("graphics/RobinFrontFrame1.png")
	player = {
		xCoord = 300,
		yCoord = 300,
		spritePos = "forward",
		inventory = {},
		hitbox = {
			{15, 50},
			{35, 50},
			{30, 75}
		}
	}
	function player:getTileCoord()
		tempX = math.floor((self.xCoord+30)/tileWidth)
		tempY = math.floor((self.yCoord+50)/tileHeight)

		return {x=tempX, y=tempY}
	end

    function player:getPlayerSprite()
        if self.spritePos == "forward" then
            tempplayerSprite = util.getImage("graphics/RobinFrontFrame1.png")
		elseif self.spritePos == "back" then
            tempplayerSprite = util.getImage("graphics/RobinBackFrame1.png")
		end
		return tempplayerSprite
	end
	

	--NPC sprite
	npc = util.getImage("graphics/Regular Jack.png")

	--Access each map from levels directory, populate maps table
	maps = {}

	local dir = "levels"
	local files = love.filesystem.getDirectoryItems(dir)
	for i, file in ipairs(files) do
		print(file:match("(.+)%..+$"))
		maps[file:match("(.+)%..+$")] = require("levels/"..file:match("(.+)%..+$"))
	end

	goToMap("floor1")
end


function goToMap(index)
	currentMap = maps[index]
	tileMap = createTileMap(currentMap.thisMap)--Initial tileMap

	local oldMapIndex = nil
	if mapIndex ~= nil then
		oldMapIndex = mapIndex
	end

	mapIndex = index


	--Associate switches to lamps through connection data in level
	if currentMap.thisConnections ~= nil then
		for i = 1, #currentMap.thisConnections do
			local connections = currentMap.thisConnections[i]
			local tile = tileMap[connections[1]][connections[2]]
			tile:addConnection(connections[3], connections[4])
		end
	end

	--Position player at correct coordinates
	for i = 1, #currentMap.thisDoors do
		if currentMap.thisDoors[i].goesTo == oldMapIndex then
			teleportToTile(currentMap.thisDoors[i].x, currentMap.thisDoors[i].y)
			break
		end
	end
end

function teleportToTile(x, y)
	local newLoc = tileToCoords(x, y)
	player.xCoord = newLoc.x
	player.yCoord = newLoc.y+tileHeight-51
end


function love.update(dt)
	local slowVelX = 80
	local slowVelY = 80
	local fastVelX = 190
	local fastVelY = 190
	local velX = 0
	local velX = 0

	local tcBefore = player:getTileCoord()
<<<<<<< HEAD

=======
	playerSprite = player:getPlayerSprite()
	
>>>>>>> c46458345e7dbf9b33f8042c740fb6bada21861c
	--Speed up when shift is pressed
	if love.keyboard.isDown("lshift") then
		velX = fastVelX
		velY = fastVelY
	else
		velX = slowVelX
		velY = slowVelY
	end

	--Arrow keys for movement
	if love.keyboard.isDown("up") then
	    player.spritePos = "back"
		if (canMoveTo(player.xCoord, player.yCoord - velY * dt)) then
			player.yCoord = player.yCoord - (velY * dt)
		end
	end
	if love.keyboard.isDown("down") then
        player.spritePos = "forward"
		if (canMoveTo(player.xCoord, player.yCoord + velY * dt)) then
			player.yCoord = player.yCoord + (velY * dt)
		end
	end
	if love.keyboard.isDown("left") then
		if (canMoveTo(player.xCoord - velX * dt, player.yCoord)) then
			player.xCoord = player.xCoord - (velX * dt)
		end
	end
	if love.keyboard.isDown("right") then
		if (canMoveTo(player.xCoord + velX * dt, player.yCoord)) then
			player.xCoord = player.xCoord + (velX * dt)
		end
	end

	local tcAfter = player:getTileCoord()
	if (tcBefore.x ~= tcAfter.x or tcBefore.y ~= tcAfter.y) then
		print(tcBefore.y.." "..tcAfter.y)
		tileMap[tcAfter.y][tcAfter.x]:onEnter()
	end
end

function love.draw()
	local roomWidth = #tileMap[1]
	local roomHeight = #tileMap

	--Draw the tilemap background (floor) first
	for row = 1, roomHeight do
		for col = 1, roomWidth do
			local toDraw = tiles.floor:getImage()
			love.graphics.draw(toDraw, col*tileWidth, row*tileHeight, 0,
				tileWidth/toDraw:getWidth(), tileHeight/toDraw:getHeight())
		end
	end

	--Draw everything other than the floor
	for row = 1, roomHeight do
		for col = 1, roomWidth do
			if tileMap[row][col].name ~= "floor" then
				local toDraw = tileMap[row][col]:getImage()
				love.graphics.draw(toDraw, col*tileWidth, row*tileHeight, 0,
					tileWidth/toDraw:getWidth(), tileHeight/toDraw:getHeight())
			end
		end
	end

	--Draw player
	love.graphics.draw(playerSprite, player.xCoord, player.yCoord, 0,
		50/playerSprite:getWidth(), 70/playerSprite:getHeight())

	--Draw player hitbox for debugging
	for i = 1, #player.hitbox do
		local hitboxPoint = player.hitbox[i]
		local xDraw = hitboxPoint[1]+player.xCoord
		local yDraw = hitboxPoint[2]+player.yCoord
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", xDraw, yDraw, 3, 3)
		love.graphics.setColor(255,255,255)
	end

	if player.isDead then
		goToMap("floor1")
	end
	--Uncomment to draw tile borders
	--------------------------------
	for row = 1, roomHeight do
		for col = 1, roomWidth do
			love.graphics.rectangle("line", col*tileWidth, row*tileHeight, tileWidth, tileHeight)
		end
	end
end

--Fullscreen functionality
function love.keypressed(key)
	if key == "f" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end

function createShader()
	myShader = love.graphics.newShader[[

	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
	  	vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color

	  	/*pixel.r = pixel.r * 0.7;
	  	pixel.g = pixel.g * 0.7;
	  	pixel.b = pixel.b * 0.7;*/

		return pixel;
	}
	]]
end
