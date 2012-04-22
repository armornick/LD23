

function table.indexof(list, object)
	local i = 1
	while true  do  
		if not list[i] then break else if list[i] == obj then return i end  end
		i = i + 1
	end
end

util = {}

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function util.collides(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function util.iterate (list, callback)
	local i = 1
	while true  do  
		if not list[i] then break else callback(list[i])  end
		i = i + 1
	end
end

function util.validlocation (pos)
	local x, y = unpack(pos)
	local scrwidth, scrheight = love.graphics.getWidth() - 100, love.graphics.getHeight() - 100
	--return ( x >= 0 ) and ( y >= 0 ) and ( x <= scrwidth ) and ( y <= scrheight )
	return util.collides(50,50,scrwidth,scrheight, x,y,24,24)
end

function util.make_pos(x, y)
	local pos = {}
	table.insert(pos, x)
	table.insert(pos, y)
	return pos
end


