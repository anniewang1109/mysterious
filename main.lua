--line that makes graphics look better
love.graphics.setDefaultFilter( "nearest" )
--not sure what this is
io.stdout:setvbuf("no")

--syntax for including/accessing another script
util = require("scripts.util")

--global num variable
num = 0

--Write comments with "--"

--local num = 0

--[[ Write multi-line comments with --[[ "my comment" ]]
--[[
By default, variables in Lua are global and can be accessed from any file at any time.
Use the keyword "local" when you don't want a global variable (i.e., most of the time)
]]


--function that is called automatically on program load
function love.load()
	num = 1
end


--update function called every frame
function love.update(dt)
	num = num+1
	--print with print function (like System.out.print, print in Python, etc.)
	print(num)

	--[[

	An example of variables in Lua:

	local table = {}
	table["asdf"] = 1
	table["qwer"] = {1, 2, 3}

	local example = {}
	table[-1] = example


	]]
end


--draw function called every frame
function love.draw()
	--set background color
	love.graphics.setBackgroundColor(240, 0, 0)

	local character = util.getImage("graphics/herman.png")
	--draw takes parameters: image, x, y, rotation, scaleX, scaleY
	--can take two more at end, but these are pretty irrelevant
	love.graphics.draw(character, 100, 100, 0, 1, 1)

end