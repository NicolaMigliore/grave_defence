function _player_i()
    interact_anim_speed=0.03
    player_anim_speed=0.05
    last_player_dx=0
    last_player_dy=0
    movement_time=10
    player={
        x=64,
        y=64,
        speed=0.75,
        sprites={32,33,34,35},
        spr_i=1,
        interact_x=64+8,
        interact_y=64,
        -- interact_sprites={17,18,19,18},
        interact_sprites={17},
        interact_spr_i=1,
        ox=0,
        oy=0,
        dx=0,
        dy=0,
        movement_cd=0
    }
    show_auras = false
end

function _player_u()
    move_player()
    player_controll()

    --update animations
    if player.spr_i<#player.sprites+1-player_anim_speed then
        player.spr_i+=player_anim_speed
    else
        player.spr_i=1
    end

    if player.interact_spr_i<#player.interact_sprites+1-interact_anim_speed then
        player.interact_spr_i+=interact_anim_speed
    else
        player.interact_spr_i=1
    end
end

function _player_d()
    --draw player
    local sprite = player.sprites[flr(player.spr_i)]
    if snap_ctrl==false then
        spr(sprite,player.x,player.y)
    else
        local px,py = player.x+player.ox, player.y+player.oy
	    spr(sprite,px,py)
    end
    -- draw player interaction cursor
    local ic_x = player.interact_x
    local ic_y = player.interact_y
    local ic_spr = player.interact_sprites[flr(player.interact_spr_i)]
    --spr(ic_spr,ic_x,ic_y)
end

--- move the player based on the given inputs
function move_player()
    local old_x = player.x
    local old_y = player.y
    if snap_ctrl==false then
        local dx,dy = 0,0
        
        if (btn(⬆️)) dy=-1 last_player_dy=dy last_player_dx=0
        if (btn(⬇️)) dy=1 last_player_dy=dy last_player_dx=0
        if (btn(➡️)) dx=1 last_player_dx=dx last_player_dy=0
        if (btn(⬅️)) dx=-1 last_player_dx=dx last_player_dy=0
        

        -- check if moving diagonally
        if dx*dy != 0 then
            dx=dx/1.414*player.speed
            dy=dy/1.414*player.speed

            --avoid cobblestoning
            player.x=flr(player.x)+0.5
            player.y=flr(player.y)+0.5
        end

        -- move player horizontally
        player.x+=dx
        
        -- check for collision
        local player_bbox={
            player.x+3,            --player coords + offset for bound box of sprite
            player.y+4,            --player coords + offset for bound box of sprite
            player.x+5,            --player coords + offset for bound box of sprite
            player.y+5             --player coords + offset for bound box of sprite
        }

        local lvl_offset = (selected_lvl-1) * 128
        if collide(player_bbox)
        or player.x < 0 + lvl_offset
        or player.x > 121 + lvl_offset then
            player.x=old_x
        end

        -- move player vertically
        player.y+=dy

        -- check for collision vertically
        player_bbox={
            player.x+3,
            player.y+4,
            player.x+5,
            player.y+5 
        }

        if collide(player_bbox)
        or player.y < 0
        or player.y > 110 then
            player.y=old_y
        end

        -- update interaction cursor
        player.interact_x = flr((player.x+4+(8*last_player_dx))/8)*8            --center player sprite + ofset for movement direction
        player.interact_y = flr((player.y+4+(8*last_player_dy))/8)*8
    else
        -- Snap controlls enabled
        if player.movement_cd==0 then
            player.dx=0
            player.dy=0
            local btn_pressed=nil
            for i=0,3 do
                if(btn(i)) btn_pressed=i
            end
            if btn_pressed != nil then
                -- horizontal movement
                if (btn_pressed==0) player.x-=8 player.dx=-1
                if (btn_pressed==1) player.x+=8 player.dx=1

                -- vertical movement
                if (btn_pressed==2) player.y-=8 player.dy=-1
                if (btn_pressed==3) player.y+=8 player.dy=1

                -- check for collision horizontally
                local player_bbox={
                    player.x+3,            --player coords + offset for bound box of sprite
                    player.y+4,            --player coords + offset for bound box of sprite
                    player.x+5,            --player coords + offset for bound box of sprite
                    player.y+5             --player coords + offset for bound box of sprite
                }

                local lvl_offset = (selected_lvl-1) * 128
                if collide(player_bbox)
                or player.x < 0 + lvl_offset
                or player.x > 121 + lvl_offset
                or player.y < 0
                or player.y > 110 then
                    player.x=old_x
                    player.y=old_y
                else
                    player.movement_cd=movement_time
                end
            end
        else
            player.movement_cd-=1
        end

        -- animate transition between snapped locations
        local perc = easeinoutquad(1-player.movement_cd/movement_time)
        player.ox = (8-perc*8) * -player.dx
        player.oy = (8-perc*8) * -player.dy
    end
end

-- place torches
function player_controll()
    --place torch
    if btnp(❎) then
        local tile_x,tile_y=flr((player.x+4)/8),flr((player.y+4)/8) --player.interact_x/8, player.interact_y/8
        local tile = mget(tile_x,tile_y)
        local lvl_offset = (selected_lvl-1) * 16
        local tile_in_bounds = 
            tile_x >= 0 + lvl_offset and
            tile_x <= 15 + lvl_offset and
            tile_y >= 0 and tile_y <= 14
        --empty space
        if tile==0 and available_torches>0 and tile_in_bounds then
            add_torch(tile_x,tile_y,1,nil)
            available_torches-=1
            spawn_smoke(player.x+4,player.y+4,{8,9,10})
        elseif tile == 1 or tile == 2 then
            del_torch(tile_x,tile_y)
            available_torches+=1
        elseif tile==0 and available_torches==0 then
            sfx(3)
            blink_txt_torch_timer=30
        elseif tile != 0 and tile != 1 then
            sfx(3)
        end
    end
    -- toggle flame auras
    if (btnp(🅾️)) show_auras = not show_auras
end

function collide(bounding_box)
    local tile_x1=bounding_box[1]/8
    local tile_y1=bounding_box[2]/8
    local tile_x2=bounding_box[3]/8
    local tile_y2=bounding_box[4]/8

    -- check all map tiles overlapped by the bounding box 
    local a = fget(mget(tile_x1,tile_y1,0))==1
    local b = fget(mget(tile_x2,tile_y1,0))==1
    local c = fget(mget(tile_x2,tile_y2,0))==1
    local d = fget(mget(tile_x1,tile_y2,0))==1

    if a or b or c or d then
        return true
    else
        return false
    end
end

--- if the snap controls are activate later, the player
--      position must be set to the correct coords.
function snap_player_to_grid()
    local old_x, old_y = player.x, player.y
    local lvl_offset = (selected_lvl-1) * 16
    local found_placement= false
    local offsets = {{0,0},{1,0},{-1,0},{0,1},{0,-1},{-1,-1},{1,1},{1,-1},{-1,1}}
    local i = 1
    while i<10 and found_placement==false do
        -- try new placement
        -- snap player to the grid
        player.x = (flr(player.x/8) * 8) + offsets[i][1]*8
        player.y = (flr(player.y/8) * 8) + offsets[i][2]*8

        local player_bbox = {
            player.x+3,
            player.y+4,
            player.x+5,
            player.y+5 
        }

        if collide(player_bbox)
        or player.x < 0 + lvl_offset
        or player.x > 121 + lvl_offset
        or player.y < 0
        or player.y > 110 then
            found_placement = false
        else 
            found_placement = true
        end
    end
end