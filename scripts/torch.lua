function _torch_i()
    torch_anim_speed=0.1
    t_fire_time=120
    t_max_id=0
    torches={}
    shots={}
end

function _torch_u()
    -- update torches
    for k,t in pairs(torches) do
        --update animations
        if t.pf_id!=0 then 
            t.fire_cd-=1

            -- shot cooldown
            if t.fire_cd==0 then
                t.fire_cd=t_fire_time
                fire_enemy(t)
            end

            -- link particles cooldown
            t.link_particle_cd-=1
            if t.link_particle_cd<0 then
                t.link_particle_cd=180
                -- todo: spawn particles (flames)
                local pf = get_pflame(t.pf_id)
                local mid_x2, mid_y2 = middle_point(pf.x+4,pf.y+4,t.x*8+4,t.y*8+4)
                local mid_x1, mid_y1 = middle_point(pf.x+4,pf.y+4,mid_x2,mid_y2)
                local mid_x3, mid_y3 = middle_point(mid_x2,mid_y2,t.x*8+4,t.y*8+4)
                spawn_smoke(mid_x1,mid_y1,pf.colors)
                spawn_smoke(mid_x2,mid_y2,pf.colors)
                spawn_smoke(mid_x3,mid_y3,pf.colors)
            end

            -- torch animation
            if t.spr_i<#t.sprites+1-torch_anim_speed then
                t.spr_i+=torch_anim_speed
            else
                t.spr_i=1
            end
        end
    end

    -- update shots
    for s in all(shots) do 
        local dx = s.x - s.target_x
        local dy = s.y - s.target_y

        s.x -= dx * s.speed
        s.y -= dy * s.speed

        -- check if hit enemy
        local found_enemy=false
        local i=0
        while i<#enemies and found_enemy!=true do
            i+=1
            local e = enemies[i]
            if hitbox_collide(
                {s.x-1,s.y-1,4,4},
                {e.x,e.y,8,8}) 
            then
                hit_enemy(e,s.damage)
                despawn_shot(s)
                sfx(2)
                found_enemy=true
            end
        end

        -- despawn shots that have reached destination
        if abs(dx) < 0.5 and abs(dy) < 0.5 then
            despawn_shot(s)
        end

        -- trail particles
        spawntrail(s.x,s.y,s.colors)
    end
end

function _torch_d()
    -- for t in all(torches) do
    --     local spr_i=t.sprites[1]
    --     -- set sprite for unpowerd torch
    --     if (t.pf_id==0) spr_i=2

    --     -- draw torch
    --     spr(spr_i,t.x,t.y)
    -- end
    -- if torches[1] != nil then
    --     debug=torches[1].pf_id
    -- end
    for t in all(torches) do
        if t.pf_id!=0 then
            -- local pf=pflames[tostr(t.pf_id)]
            local pf=get_pflame(t.pf_id)
            if pf!=nil then
                pal(9,pf.colors[1])
                pal(10,pf.colors[2])
                pal(7,pf.colors[3])
                spr(t.sprites[flr(t.spr_i)],t.x*8,t.y*8)
                pal()
            end
        --else
            
        end
    end

    -- draw shots
    for s in all(shots) do 
        circfill(s.x,s.y,2,s.c)
    end
end

function get_torch(_id)
    for t in all(torches) do
        if (t.id == _id) return t
    end
    return nil
end

-- create a new torch
function add_torch(_x,_y,_kind,_pf_id)
    -- kinds: 1: basic torch
    local linkable=get_linkable_flames(_x*8,_y*8)
    local near_pf_id=rnd(linkable) or 0
    _pf_id=_pf_id or near_pf_id

    t_max_id+=1
    local new_torch = {
        id=t_max_id,
        x=_x,
        y=_y,
        kind=_kind,
        pf_id=_pf_id,           -- ID of power flame that poweres the torch
        fire_cd=t_fire_time,    -- cooldown for firing
        sprites={3,4,5},
        spr_i=1,
        range=32,
        damage=5,
        link_particle_cd=60
    }
    link_torch(new_torch,_pf_id)
    add(torches,new_torch)
    -- torches[tostr(t_max_id)]=new_torch
    mset(_x,_y,1)
end

-- delete the torch a the give tile coords
function del_torch(_x,_y)
    for k,t in pairs(torches) do
        if t.x==_x and t.y==_y then
            -- clear link
            if t.pf_id != 0 and t.pf_id != nil then
                --local pf = pflames[tostr(t.pf_id)]
                local pf=get_pflame(t.pf_id)
                del(pf.ltorches,t.id)
            end
            del(torches,t)
            mset(_x,_y,0)
            return
        end
    end
end

-- create link with power flame
function link_torch(_t,_pf_id)
    --local pf = pflames[_pf_id]
    local pf=get_pflame(_t.pf_id)
    if pf==nil then return end

    add(pf.ltorches,_t.id)
end

-- returns a list of all flames that are linkable based on the provided coords
function get_linkable_flames(_x,_y)
    local linkable={}
    for k,pf in pairs(pflames) do
        local dist=point_dinstance(pf.x,pf.y,_x,_y)
        if (pf.power>0 and dist<=pf_aura_r) add(linkable,pf.id)
    end
    return linkable
end


function fire_enemy(_t)
    local torch_x, torch_y = _t.x*8+4, _t.y*8+4
    for e in all(enemies) do
        local dist=point_dinstance(torch_x,torch_y,e.x,e.y)
        if dist<=_t.range then
            local pf=get_pflame(_t.pf_id)
            local color=pf.colors[1]
            local new_shot={
                x=torch_x,
                y=torch_y,
                target_x=e.x+4,
                target_y=e.y+4,
                damage=pf.damage+_t.damage,
                speed=0.1,
                colors=pf.colors,
                c=color
            }
            add(shots,new_shot)
            local power_delta
            if pf.kind==2 then
                power_delta = 0.7
            elseif pf.kind==3 then
                power_delta = 0.1
            else
                power_delta = 0.5
            end
            consume_flame(_t.pf_id, 0.7)
            return
        end
    end
end

-- delete shot and activate fxs
function despawn_shot(_s)
    del(shots,_s)
    -- todo: play sound fx
    -- todo: display smoke particles
end

function torch_tostr(_t)
    if (_t==nil) return "nil"
    local str = "{id:".._t.id
    str = str..",pf_id:".._t.pf_id
    str = str.."}"

    return str
end
