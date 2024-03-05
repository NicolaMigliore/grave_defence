function _particles_i()
    particles={}
    fades = {1,5,13,6}
end

function _particles_u()
    for key,p in pairs(particles) do
        p.age+=1
        if (p.age >= p.max_age) del(particles,p)

        -- age of particle from 0 to 1
        local age_perc = p.age/p.max_age

        -- change color
        if #p.colors > 1 then
            -- color index based on age
            local color_i = flr(age_perc * #p.colors)+1
            p.color=p.colors[color_i]
        end

        --shrink
		if p.kind==1 then
			p.size=(1-age_perc)*p.max_size
		end

        --friction
		if p.kind==3 then
			p.dx=p.dx/1.2
			p.dy=p.dy/1.2
		end

        --move particle
		p.x+=p.dx
		p.y+=p.dy
    end
end

function _particles_d()
    for key,p in pairs(particles) do
        if p.kind==0 then
            pset(p.x,p.y,p.color)
        elseif p.kind==1 then
            circfill(p.x,p.y,p.size,p.color)
        elseif p.kind==2 then
            -- age of particle from 0 to 1
            -- if p.age < 75 then

            -- elseif p.age > 150  then 

            -- end
            --rect(p.x,p.y,p.x+p.size,p.y+p.size,fades[flr(sin(p.age/p.max_age)*6)])
            rect(p.x,p.y,p.x+p.size,p.y+p.size,p.color)
        end
    end
end

function add_particle(_x,_y,_dx,_dy,_kind,_max_age,_colors,_size)
    -- kind 0 - static pixel
    -- kind 1 - ball of smoke
    -- kind 2 - ash
    local new_particle={
        x=_x,
        y=_y,
        dx=_dx,
        dy=_dy,
        kind=_kind,
        age=0,
        max_age=_max_age,
        colors=_colors,
        color=_colors[1],
        size=_size,
        max_size=_size
    }
    add(particles,new_particle)
end

-- spawn trail particles
function spawntrail(_x,_y,_colors)
	if rnd() < 0.5 then return end

	local angle = rnd()
	local offset_x = sin(angle)*0.6
	local offset_y = cos(angle)*0.6
	
	add_particle(
		_x+offset_x,
		_y+offset_y,
		0,
		0,
		0,
		15+rnd(15),
		_colors--{10,10,9,8}
	)
end

--spawn fmoke
function spawn_smoke(_x,_y,_colors)
	for i=0, 2+rnd(4) do
		local angle = rnd()
		local _dx = sin(angle)*0.05
		local _dy = cos(angle)*0.05
		add_particle(_x,_y,_dx,_dy,1,30,_colors,0.5+rnd(2))
	end
end

function spawn_ash(_x,_y,_colors,_size)
    _size = _size or ceil(rnd(1.5))-1
    local angle = rnd()
	local _dx = sin(angle)*0.05
	local _dy = cos(angle)*0.05
    add_particle(_x,_y,_dx,_dy,2,rnd(150),_colors,_size)
end