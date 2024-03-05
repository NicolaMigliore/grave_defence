-- power flames are required to power towers.
-- power flames are bord strong, but their power decreases based on the number adiecent towers.
-- their power goes down periodically if overtapped. Power flames can die.
function _pf_i()
    pf_grow_time=60
    pf_max_id=0
    pf_aura_r=24
    pflames={}
    
    pf_anim_speed=0.1
    
    debug_pf_aura=false
end

function _pf_u()
    for k,pf in pairs(pflames) do
        if pf.power>0 then
            -- grow flames
            pf.grow_cd-=1
            if pf.grow_cd == 0 then
                pf.grow_cd=pf_grow_time
                if pf.power<pf.max_power then
                    pf.power=min(pf.power+1, pf.max_power)
                end
            end
        end
    end
end

function _pd_d()
    for k,pf in pairs(pflames) do
        if pf.power>0 then 
            if pf.spr_i<#pf.sprites+1-pf_anim_speed then
                pf.spr_i+=pf_anim_speed
            else
                pf.spr_i=1
            end

            pal(9,pf.colors[1])
            pal(10,pf.colors[2])
            pal(7,pf.colors[3])
            local spr_x=48+(flr(pf.spr_i)*8)
            local spr_size=8/pf.max_power*pf.power
            sspr(spr_x,0,7,7,pf.x,pf.y-spr_size/3,spr_size,spr_size)
            -- spr(pf.sprites[flr(pf.spr_i)],pf.x,pf.y)

            if debug_pf_aura then
                circ(pf.x+4,pf.y+4,pf_aura_r,pf.colors[1])
                print(pf.power,pf.x,pf.y-6)
            end

            for t_id in all(pf.ltorches) do
                local t = get_torch(t_id)
                draw_link_particles(
                    {pf.x,pf.y,spr_size,spr_size},
                    {t.x*8,t.y*8,8,8},
                    pf.colors[1]
                )
            end
            pal()
        end
    end
end

function get_pflame(_id)
    for pf in all(pflames) do
        if pf.id == _id then 
            return pf
        end
    end
    return nil
end

function add_pflame(_x,_y,_power,_kind)
    local i = flr(rnd(4))+1
    pf_max_id+=1

    -- manage different flame types
    local max_power,damage,colors

    if _kind==2 then
        max_power = 2
        damage = 10
        colors = {2,8,15}
    elseif _kind==3 then
        max_power = 4
        damage = 5
        colors = {1,12,13}
    else 
        max_power = 3
        damage = 7
        colors = {9,10,7}
    end
    
    local new_flame = {
        id=pf_max_id,
        x=_x,
        y=_y,
        power=_power,
        max_power=max_power,
        damage=damage,
        colors=colors,
        sprites={7,8,9,10,11},
        spr_i=i,
        grow_cd=pf_grow_time,               --cooldown for flame to grow
        ltorches={}                         --list of id of linked torches
    }
    --pflames[tostr(pf_max_id)]=new_flame
    add(pflames,new_flame)
end

function del_flame(_pf)
    --clear id from torches
    for t_id in all(_pf.ltorches) do
        local t = get_torch(t_id)
        t.pf_id = 0
        --torches[t_id].pf_id=0
    end

    --delete power flame
    --del(pflames, _pf)
end

function consume_flame(_id,_power_delta)
    -- local pf = pflames[tostr(_id)]
    local pf = get_pflame(_id)
    if (pf==nil) return

    pf.power-=_power_delta
    -- remove flames with no power
    if (pf.power<=0) del_flame(pf)
end

function draw_link_particles(_hb1,_hb2,_c)
    local hb1_x,hb1_y,hb1_w,hb1_h = unpack(_hb1)
	local hb2_x,hb2_y,hb2_w,hb2_h = unpack(_hb2)
    local p1_x,p1_y = flr(hb1_x+hb1_w/2),flr(hb1_y+hb1_h/2)
    local p2_x,p2_y = flr(hb2_x+hb2_w/2),flr(hb2_y+hb2_h/2)
    if (debug_pf_aura) line(p1_x,p1_y,p2_x,p2_y,_c)
end

--spawn initial level flames
function spawn_flames(_ox)

    for i=0+_ox,15+_ox do
        for j=0,15 do 
            local map_tile = mget(i,j)
            if map_tile>11 and map_tile<16 then
                local power=rnd({1,2})
                local kind=1
                local theme={9,10,7}--rnd(flame_themes)
                if(map_tile==13) kind = 2
                if(map_tile==14) kind = 3
                if(map_tile==15) kind = rnd({1,2,3})
                add_pflame(i*8,j*8,power,kind)
            end
        end
    end
end 
