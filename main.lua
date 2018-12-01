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
		inventory = {},
		hitbox = {
			{10, 45},
			{45, 45}
		}
	}

	--NPC sprite
	npc = util.getImage("graphics/Regular Jack.png")

	--Access each map from levels directory, populate maps table
	maps = {}

	local dir = "levels"
	local files = love.filesystem.getDirectoryItems(dir)
	for i, file in ipairs(files) do
		maps[i] = require("levels/"..file:match("(.+)%..+$"))
	end

	--Initial tileMap
	currentMap = maps[1]
	tileMap = createTileMap(currentMap.thisMap)

	--Associate switches to lamps through connection data in level
	if currentMap.thisConnections ~= nil then
		for i = 1, #currentMap.thisConnections do
			local connections = currentMap.thisConnections[i]
			tileMap[connections[1]][connections[2]]:onLoad(connections[3], connections[4])
		end
	end
end

function love.update(dt)
	local slowVelX = 80
	local slowVelY = 80
	local fastVelX = 190
	local fastVelY = 190
	local velX = 0
	local velX = 0

	local tcBefore = getTileCoord(player.xCoord+35, player.yCoord+35)
	
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
	    playerSprite = util.getImage("graphics/RobinBackFrame1.png")
		if (canMoveTo(player.xCoord, player.yCoord - velY * dt)) then
			player.yCoord = player.yCoord - (velY * dt)
		end
	end
	if love.keyboard.isDown("down") then
        playerSprite = util.getImage("graphics/RobinFrontFrame1.png")
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
	
	local tcAfter = getTileCoord(player.xCoord+35, player.yCoord+35)
	if (tcBefore.x ~= tcAfter.x or tcBefore.y ~= tcAfter.y) then
		tileMap[tcAfter.y][tcAfter.x]:onEnter()
	end
	------------------------------------------------------------------------------
	-- if(getTileCoord(player.xCoord, player.yCoord).x == maps[1].thisDoor.x and
	-- 	(getTileCoord(player.xCoord, player.yCoord).y == maps[1].thisDoor.y)) then
	-- 	print("TOUCHING DOOR")
	-- end
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

	--Uncomment to draw tile borders
	--------------------------------
	-- for row = 1, roomHeight do
	-- 	for col = 1, roomWidth do
	-- 		love.graphics.rectangle("line", col*tileWidth, row*tileHeight, tileWidth, tileHeight)
	-- 	end
	-- end
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