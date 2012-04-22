
ai = {}

function ai.DoNothing ()
	self = {}
	self.exec = function(parent) end
	self.collide = function(parent, other) end
	return self
end

function ai.RandomWalker ( )
	self = {}
	
	function self.exec(parent)
		if math.random(100) > 50 then
			local x, y = unpack(parent.position)
			local dx, dy = math.random(-5, 5), math.random(-5, 5)
			--local dx, dy = math.random(-24, 24), math.random(-24, 24)
			if util.validlocation( {x + dx, y + dy} ) then parent.position = { x + dx, y + dy } end
		end					
	end
	
	function self.collide(parent, other)
		if other.char == '#' then other.status = 'd' end
	end
	
	return self
end

function ai.RandomMother ( )
	self = {}
	
	function self.exec(parent)
	
		if math.random(100) > 65 then
			local x, y = unpack(parent.position)
			local dx, dy = math.random(-10, 10), math.random(-10, 10)
			--local dx, dy = math.random(-24, 24), math.random(-24, 24)
			if util.validlocation( {x + dx, y + dy} ) then parent.position = { x + dx, y + dy } end
		end	
	end
	
	function self.collide(parent, other)
		if parent.cooldown < 5 and parent.char == other.char then
			enemies:insert( tlFactory.new_walker(parent.position) )
			parent.cooldown = parent.cooldown + 1
		end
	end
	
	return self
end

function ai.Bomb()
	self = {}
	self.exec = function(parent) end
	
	function self.collide(parent, other)
		if other.type == 'c' then other.status = 'd' end
		parent.status = 'd'
	end
	
	return self
end