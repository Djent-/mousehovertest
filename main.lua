hover = {}

function hover:new(ID, _function, x, y, widthOrRadius, height)
	local self = {}
	self.ID = ID
	self.x = x
	self.y = y

	--rectangular or circular bounding box
	--peaks will want circular, buttons will want rectangular
	if height then self.width = widthOrRadius; self.height = height else
	self.radius = widthOrRadius end

	--to be set later
	self._function = _function or function(self) return end
	return self
end

function love.load()
	points = {}
	local f = function(self)
		for x = 1, #points do
			if points[x].ID == self.ID then
				points[x].visible = true
				print("Set " .. x .. " visible")
			else
				points[x].visible = false
			end
		end
	end
	for x = 1, 5 do
		local _x = math.random(love.graphics.getWidth())
		local _y = math.random(love.graphics.getHeight())
		points[x] = hover:new(tostring(x),f,_x,_y,10)
	end
end

function love.update(dt)
	updatePoints()
end

function love.draw()
	for a = 1, #points do
		if points[a].visible then
			if points[a].width then
				love.graphics.rectangle("fill", points[a].x, points[a].y, points[a].width, points[a].height)
			else
				love.graphics.circle("fill", points[a].x, points[a].y, points[a].radius)
			end
		else
			if points[a].height then
				love.graphics.rectangle("line", points[a].x, points[a].y, points[a].width, points[a].height)
			else
				love.graphics.circle("line", points[a].x, points[a].y, points[a].radius)
			end
		end
	end
end

function updatePoints()
	local _x, _y = love.mouse.getPosition()
	print(_x, _y)
	love.graphics.print(_x .. " " .. _y, 5, 5)
	for a = 1, #points do
		--check if the hover is a circle or rectangle
		--if it's a rectangle check if the mouse is in it
		--if not, do the distance formula and see if the mouse is within the radius
		if points[a].width then
			--it's a rectangle
			if _x >= points[a].x and _y >= points[a].y then
				if _x <= points[a].x + points[a].width and _y <= points[a].y + points[a].height then
					points[a]:_function()
					print("Updated " .. a)
					love.graphics.print("Updated", points[a].x, points[a].y - 7)
				end
			end
		else
			--it's a circle
			local dist = (_x - points[a].x)^2 + (_y - points[a].y)^2
			if dist <= (points[a].radius)^2 then
				points[a]:_function()
				print("Updated " .. a)
				love.graphics.print("Updated", points[a].x - 15, points[a].y - 7)
			end
		end
	end
end
