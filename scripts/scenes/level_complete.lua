function _lvl_complete_u()
    if (btnp(❎)) change_mode_level_select()

    text_anim_time+=1/120
    if(text_anim_time>1) text_anim_time=0
    banner_anim_time+=1/240
    if(banner_anim_time>1) banner_anim_time=0
    
end

function _lvl_complete_d()
    local camera_ox = (selected_lvl-1)*128
    --clip(0+camera_ox,30,128,17)
    rectfill(0+camera_ox,30,128+camera_ox,47,2)
    print("level complete",40+camera_ox,32,6)
    print("press ❎ to continue",28+camera_ox,40,blink_color1.color)

    -- local text_x,banner_w,banner_h
    -- --linear
    -- banner_w = 128
    -- banner_x2 = easeoutinquart(banner_anim_time) * 256
    -- banner_x1 = banner_x2-banner_w
    -- banner_h = easeoutinquart(banner_anim_time) * 60 
    -- --clip(0,30,banner_w,banner_h)
    -- cls()
    -- rectfill(banner_x1,30,banner_x2,30+banner_h,2)
    -- circfill(banner_x1,40,4,12)
    -- circfill(banner_x2,40,4,8)

    -- -- --easing
    -- -- text_x = easeoutinquart(text_anim_time) *128
    -- -- circfill(text_x,80,4,8)

    -- -- -- todo: add offset based on selected level
    -- -- print("level complete",text_x-21,62,8)
    
end

function change_mode_level_complete()
    banner_anim_time=0
    text_anim_time=0
    shots={}            -- clear all existing shots
    _game_d()           -- draw next frame of the game
    mode="level_complete"
    --selected_lvl=1
    sfx(0)
end
