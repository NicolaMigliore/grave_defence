function _enemy_i()
    enemies={}
    enemy_anim_speed=0.05
end

function _enemy_u()
    for e in all(enemies) do 
        if rnd()>0.2 then
            move_enemy(e)
        end
        
        -- update animations
        if e.spr_i<#e.sprites+1-enemy_anim_speed then
            e.spr_i+=enemy_anim_speed
        else
            e.spr_i=1
        end

    end
end

function _enemy_d()
    if #enemies > 0 then
        for i=#enemies,1,-1 do
            local e = enemies[i]
            -- spr(64,e.x,e.y)
            local offset=e.sprite_size*4
            if e.is_hit_cnt > 0 then
                pal(7,8)
                pal(9,6)
                spr(e.sprites[flr(e.spr_i)],e.x-offset,e.y-offset,e.sprite_size,e.sprite_size)
                e.is_hit_cnt-=1
                pal()
            else
                spr(e.sprites[flr(e.spr_i)],e.x-offset,e.y-offset,e.sprite_size,e.sprite_size)
            end

        end
    end
end

function add_enemy(_x,_y,_kind,_path)
    _kind= _kind or 1
    local speed = 0.04
    local hp=40
    local sprite_size = 1
    local sprites={64,65,66,65}

    if _kind==2 then 
        hp = 80
        sprite_size = 2
        sprites = {96,98,100,98}
        speed = 0.02
    elseif _kind==3 then 
        hp = 100
        speed = 0.02
        sprite_size = 2
        sprites = {67,69,71,69}
    end
    
    local new_enemy={
        x=_x,
        y=_y,
        hp=hp,
        kind=_kind,
        path=generate_path(_path),
        speed=speed,
        sprite_size=sprite_size,
        sprites=sprites,
        spr_i=1,
        is_hit_cnt=0
    }
    add(enemies,new_enemy)
end

function del_enemy(_e)
    del(enemies,_e)

    -- check if level completed
    if (is_level_complete()) change_mode_level_complete()
end

-- generates the enemy specific path points
-- they are variations on the level paths
-- path are in the form: {{x1,y1},{x2,y2}}
function generate_path(_points)
    local path={}
    for p in all(_points) do
        local x=p[1] + rnd({0,1,2,3,4,5,6})-3
        local y=p[2] + rnd({0,1,2,3,4})-2
        add(path,{x,y})
    end
    return path
end

function move_enemy(_e)
    local target = _e.path[1]
    local dx = _e.x - target[1]
    local dy = _e.y - target[2]

    if abs(dx) < 1 and abs(dy) < 1 then
        deli(_e.path,1)
        if #_e.path > 0 then
            move_enemy(_e)
        else
            sub_soul()
            del_enemy(_e)
        end
    end

    _e.x -= dx * _e.speed
    _e.y -= dy * _e.speed
end

function hit_enemy(_e,_damage)
    _e.hp-=_damage
    _e.is_hit_cnt=3
    if (_e.hp <= 0) del_enemy(_e)
end