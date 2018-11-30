--line that makes graphics look better
love.graphics.setDefaultFilter( "nearest" )
--not sure what this is
io.stdout:setvbuf("no")

--syntax for including/accessing another script
util = require("scripts.util")
tiles = require("scripts.tiles")

--global num variable
num = 0

--Write comments with "--"

--local num = 0

--[[ Write multi-line comments with --[[ "my comment" ]]
--[[
By default, variables in Lua are global and can be accessed from any file at any time.
Use the keyword "local" when you don't want a global variable (i.e., most of the time)
]]



--[[
	Anthony:
	Here I'm iterating through each file in a new levels directory - I think it would be
	best to have a bunch of level files and then set them after a door collision is detected.
	This will make implementing the story, switching to and from puzzles, and cleaning our
	code's structure much easier.
]]




function isMovableTile(type)
	if type == 1 then
		return false
	else
		return true
	end
end

function getTileCoord(x, y)
	tempX = math.floor(x/tileWidth)
    tempY = math.floor(y/tileHeight)

	return {x=tempX, y=tempY}
end

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


--function that is called automatically on program load
function love.load()
	--[[
		Anthony:
		Here I'm iterating through each file in the levels directory and requiring each module by index.
		Now the tilemap is globally available. TODO:
		- Make each door in the level do something different
	]]
	-----------------------------------------------------
	maps = {}

	playerSprite = util.getImage("graphics/RobinFrontFrame1.png") --set image for playSprite


	local dir = "levels"
	local files = love.filesystem.getDirectoryItems(dir)
	for i, file in ipairs(files) do
		maps[i] = require("levels/"..file:match("(.+)%..+$"))
	end
	tileMap = createTileMap(maps[1][1])

	--love.window.setMode(100, 100, {})

	--[[
		player xCoord/yCoord correspond to coordinates on-screen
		on map, yCoord comes first, then xCoord (different from player)
	]]

	tileWidth = 50
	tileHeight = 50
	player = {
		xCoord = 50,
		yCoord = 50,
		inventory = {},
		hitbox = {
			{10, 45},
			{45, 45}
		}

	}

end


--update function called every frame
function love.update(dt)


	local slowVelX = 80
	local slowVelY = 80
	local fastVelX = 190
	local fastVelY = 190
	local velX = 0;
	local velX = 0;

	local tcBefore = getTileCoord(player.xCoord+35, player.yCoord+35)
	--speed up if shift is down
	if love.keyboard.isDown("lshift") then
		velX = fastVelX
		velY = fastVelY
	else
		velX = slowVelX
		velY = slowVelY
	end
	if  love.keyboard.isDown("up") then
	    playerSprite = util.getImage("graphics/RobinBackFrame1.png")
		if (canMoveTo(player.xCoord, player.yCoord - velY * dt)) then
			player.yCoord = player.yCoord - (velY * dt)
		end
	end
	if  love.keyboard.isDown("down") then
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

	print("x: " .. getTileCoord(player.xCoord, player.yCoord).x .. ", y: " .. getTileCoord(player.xCoord, player.yCoord).y)

	if(getTileCoord(player.xCoord, player.yCoord).x == maps[1][2].x and
		(getTileCoord(player.xCoord, player.yCoord).y == maps[1][2].y)) then
		print("TOUCHING DOOR")
	end
end


--draw function called every frame
function love.draw()
	--set background color
	local roomWidth = 10
	local roomHeight = 10

	local tile = util.getImage("graphics/woodfloor.png")
	local wall = util.getImage("graphics/wfrontwall.png")
	local door = util.getImage("graphics/door.png")

	--draw takes parameters: image, x, y, rotation, scaleX, scaleY
	--can take two more at end, but these are pretty irrelevant

	--[[ eventual room matrix:
	room = {
		{tile1, tile2, tile3},
		{tile4, tile5, tile6}
	}
	]]

	-- map = {
	-- 	{0, 0, 0, 0, 0, 3, 0, 0, 0, 0},
	-- 	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- 	{1, 1, 1, 0, 0, 1, 1, 1, 1, 1},
	-- 	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- 	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- 	{1, 1, 1, 0, 0, 0, 0, 0, 0, 0},
	-- 	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- 	{0, 0, 2, 0, 0, 0, 0, 0, 0, 0},
	-- 	{0, 0, 2, 2, 0, 0, 1, 1, 1, 1},
	-- 	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	-- }

	-- local tileMap = createTileMap(map)

	-- equivalent of (for int row = 0; row < roomHeight; row++)

	--dra background
	for row = 1, roomHeight do
		for col = 1, roomWidth do
			local toDraw = util.getImage("graphics/woodfloor.png")
			love.graphics.draw(toDraw, col*tileWidth, row*tileHeight, 0,
				tileWidth/toDraw:getWidth(), tileHeight/toDraw:getHeight())
		end
	end

	for row = 1, roomHeight do
		for col = 1, roomWidth do
			if tileMap[row][col].name ~= "blankTile" then
				local toDraw = tileMap[row][col]:getImage()
				love.graphics.draw(toDraw, col*tileWidth, row*tileHeight, 0,
					tileWidth/toDraw:getWidth(), tileHeight/toDraw:getHeight())
			end
		end
	end

	for row = 1, roomHeight do
		for col = 1, roomWidth do
			love.graphics.rectangle("line", col*tileWidth, row*tileHeight, tileWidth, tileHeight)
		end
	end


	--draw player

	love.graphics.draw(playerSprite, player.xCoord, player.yCoord, 0,
		50/playerSprite:getWidth(), 70/playerSprite:getHeight())

	for i = 1, #player.hitbox do
		local hitboxPoint = player.hitbox[i]
		local xDraw = hitboxPoint[1]+player.xCoord
		local yDraw = hitboxPoint[2]+player.yCoord
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", xDraw, yDraw, 3, 3)
		love.graphics.setColor(255,255,255)
	end

end

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

function love.keypressed(key)
	if key == "f" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end
