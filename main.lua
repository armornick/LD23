
require "util"
require "objects"
require "ai"

fontsize = 24 	-- system font size

-- enemies table
enemies = {}
	enemies.insert = table.insert
	enemies.remove = table.remove
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_mother( {math.random(50, love.graphics.getWidth()),  math.random(50, love.graphics.getHeight())} ) )
	enemies:insert( tlFactory.new_walker( {200, 200} ) ) 
	enemies:insert( tlFactory.new_walker( { 75,  75} ) )
	enemies:insert( tlFactory.new_walker( { 88,  88} ) )
	enemies:insert( tlFactory.new_walker( {150,  400} ) )

-- minions table
minions = {}
	minions.insert = table.insert
	minions.remove = table.remove
	minions:insert( tlFactory.new_crate( { 50, 50} ) )
	minions:insert( tlFactory.new_crate( { 100, 100} ) )

-- game state data
GameState = {
	selected = "*",
	started = false,
	victory = false,
}

function do_collision()
	
	local i = 1
	while true  do  
		if not minions[i] then break 
		else 
			local j = 1
			while true  do  
				if not enemies[j] then break 
				else 
					local ax1, ay1, aw, ah = minions[i].position[1], minions[i].position[2], fontsize, fontsize
					local bx1, by1, bw, bh = enemies[j].position[1], enemies[j].position[2], fontsize, fontsize
					if util.collides(ax1,ay1,aw,ah, bx1,by1,bw,bh) then
						minions[i]:collide(enemies[j])
					end
				end
				j = j + 1
			end
			
			j = 1
			while true  do  
				if not minions[j] then break 
				else 
					local ax1, ay1, aw, ah = minions[i].position[1], minions[i].position[2], fontsize, fontsize
					local bx1, by1, bw, bh = minions[j].position[1], minions[j].position[2], fontsize, fontsize
					if i ~= j and util.collides(ax1,ay1,aw,ah, bx1,by1,bw,bh) then
						minions[i]:collide(minions[j])
					end
				end
				j = j + 1
			end
		end
		i = i + 1
	end
	
	i = 1
	while true  do  
		if not enemies[i] then break 
		else 
			local j = 1
			while true  do  
				if not enemies[j] then break 
				else 
					local ax1, ay1, aw, ah = enemies[i].position[1], enemies[i].position[2], fontsize, fontsize
					local bx1, by1, bw, bh = enemies[j].position[1], enemies[j].position[2], fontsize, fontsize
					if i ~= j and util.collides(ax1,ay1,aw,ah, bx1,by1,bw,bh) then
						enemies[i]:collide(enemies[j])
					end
				end
				j = j + 1
			end
			
			j = 1
			while true  do  
				if not minions[j] then break 
				else 
					local ax1, ay1, aw, ah = enemies[i].position[1], enemies[i].position[2], fontsize, fontsize
					local bx1, by1, bw, bh = minions[j].position[1], minions[j].position[2], fontsize, fontsize
					if util.collides(ax1,ay1,aw,ah, bx1,by1,bw,bh) then
						enemies[i]:collide(minions[j])
					end
				end
				j = j + 1
			end
		end
		i = i + 1
	end
	
end

function objects_collect()
	local i = 1
	while true  do  
		if not minions[i] then break else if minions[i].status == 'd' then table.remove(minions, i)  end end
		i = i + 1
	end
	
	i = 1
	while true  do  
		if not enemies[i] then break else if enemies[i].status == 'd' then table.remove(enemies, i)  end end
		i = i + 1
	end
end

-- resource loading function
function love.load()
	-- window caption
	love.graphics.setCaption("TinyLife")
	-- system font (pecita)
	GameState.pecita = love.graphics.newFont("Pecita.otf", fontsize)
	GameState.sysfont = love.graphics.newFont("Gamaliel.otf", fontsize)
	love.graphics.setFont(GameState.sysfont)
	love.graphics.setColor( 220, 20, 60 )
end

-- update function
function love.update(dt)
	if GameState.started then
		objects_collect()
		if #enemies == 0 then
			if GameState.victory == false then 
				GameState.victory = true 
			end
		else
			do_collision()
			util.iterate( enemies, function (item) item:update() end )
			util.iterate( minions, function (item) item:update() end )
		end
	end
end

-- drawing function
function love.draw()
	if GameState.started == false then
		local x, y = love.graphics.getWidth() * 0.1, love.graphics.getHeight() / 4
		love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.print("You have discovered a microscopic biosphere during\n your work as Gordon Freeman.You have constructed\n a device which can lay a miniature mine with a left click.\nYou presume that these microscopic organisms\n could possibly be a threat to the world at large.\n\nIn short, click to put mines until all\n enemies are gone.", x, y)
	elseif GameState.victory == false then
		util.iterate( enemies, function (item) item:draw() end )
		util.iterate( minions, function (item) item:draw() end )
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.print("Enemies: "..#enemies, 0, 0)
	else
		local x, y = love.graphics.getWidth() * 0.1, love.graphics.getHeight() / 2
		love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.setFont(GameState.sysfont)
		love.graphics.print("Congratulations, you have eradicated all tiny life! \nYou Monster.", x, y)
	end
end

-- key press event function
function love.mousepressed(x, y, button)
	if GameState.started == false then 
		GameState.started = true
		love.graphics.setFont(GameState.pecita)
	elseif GameState.victory then love.event.push("quit") 
	elseif button == 'l' then
		--print(GameState.selected)
		minions:insert( tlFactory.new_item( GameState.selected, x, y ) )
	end
end


