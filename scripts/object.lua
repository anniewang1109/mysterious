Object = {}
function Object:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Object:instanceof(super)
	metatable = getmetatable(self)
	while metatable ~= nil do
		if metatable == super then return true end
		metatable = getmetatable(metatable)
	end
	return self==super
end

function Object:super(func, ...)
	return getmetatable(self)[func](self,unpack(arg))
end