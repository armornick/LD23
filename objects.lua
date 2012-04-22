require "util"

--------------------------------------------
--------------------------------------------
--------------------------------------------
Critter = {}
function Critter.new( char, ai, pos, stamina )
	
	local c = {}
	c.type = 'c'	-- critter type object
	c.char = char	-- character that symbolizes the critter
	c.position = pos	-- position of critter (table with 2 values)
	c.ai = ai		-- behavioral construct
	c.color = { 220, 20, 60 }
	if stamina then c.stamina = stamina else c.stamina = 100 end
	c.status = 'n'	-- status = normal (tracks tired & poisoned)
	
	c.update = function (self)
					if self.status == 'r' then
						self.stamina = self.stamina + 1
						if self.stamina >= 100 then self.status = 'n' end
					elseif self.status == 'n' then
						if self.ai then self.ai.exec(self) end
						self.stamina = self.stamina - 1
						if self.stamina <= 0 then self.status = 'r' end
					end
				end
				
	c.draw = function (self)
				if self.status ~= 'd' then
					local x, y = unpack(self.position)
					local r, g, b = unpack(self.color)
					love.graphics.setColor( r, g, b )
					love.graphics.print(self.char, x, y)
				end
			end
			
	c.collide = function(self, other)
					self.ai.collide(self, other)
				end
	
	return c
	
end

--------------------------------------------
--------------------------------------------
--------------------------------------------
Robot = {}

--------------------------------------------
--------------------------------------------
--------------------------------------------
Item = {}
function Item.new( char, ai, pos )
	
	local i = {}
	i.type = 'i'	-- critter type object
	i.char = char	-- character that symbolizes the critter
	i.position = pos	-- position of critter (table with 2 values)
	i.ai = ai		-- behavioral construct
	i.color = { 34, 139,  34 }
	i.status = 'n'	-- status = normal (tracks tired & poisoned)
	
	i.update = function (self)
					if self.ai then self.ai.exec(self) end
				end
				
	i.draw = function (self)
				if self.status ~= 'd' then
					local x, y = unpack(self.position)
					local r, g, b = unpack(self.color)
					love.graphics.setColor( r, g, b )
					love.graphics.print(self.char, x, y)
				end
			end
			
	i.collide = function(self, other)
				if self.ai then self.ai.collide(self, other) end
			end
	
	return i
	
end

--------------------------------------------
--------------------------------------------
--------------------------------------------
tlFactory = {}

function tlFactory.new_walker ( pos )
	return Critter.new( "v", ai.RandomWalker(), pos )
end
function tlFactory.new_mother ( pos )
	local temp = Critter.new( "W", ai.RandomMother(), pos )
	temp.cooldown = 1
	return temp
end
function tlFactory.new_crate ( pos )
	return Item.new( "#", ai.DoNothing() , pos )
end
function tlFactory.new_mine ( pos )
	return Item.new( "*", ai.Bomb() , pos )
end

tlFactory.items = {
		["#"] = function (pos) return tlFactory.new_crate(pos) end,
		["*"] = function (pos) return tlFactory.new_mine(pos) end
}

function tlFactory.new_item ( char, x, y )
	pos = util.make_pos(x, y)
	return tlFactory.items[char](pos)
end
