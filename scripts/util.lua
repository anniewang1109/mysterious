function P.getImage(imageSource)
	if P.images[imageSource] == nil then
		P.images[imageSource] = love.graphics.newImage(imageSource)
	end
	return P.images[imageSource]
end