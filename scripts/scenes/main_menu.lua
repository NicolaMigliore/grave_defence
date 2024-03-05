function _main_menu_i()
    mm_screen_i=0           -- main menu selected screen index
    mm_screen_anim_timer=0
    mm_screen_change_delta=0
    v=0
    music(3,500)
    ash_timer=0
    ghost_timer=-60
end

function _main_menu_u()
    if (btnp(❎)) change_mode_level_select()

    if (btnp(➡️) and mm_screen_i < 1) mm_screen_i+=1 mm_screen_anim_timer=60 mm_screen_change_delta=1
    if (btnp(⬅️) and mm_screen_i > 0) mm_screen_i-=1 mm_screen_anim_timer=-60 mm_screen_change_delta=-1

    -- todo: remove debug command 
    if (btnp(🅾️)) spawn_ash(100,100,{6,5,13})
    if (mm_screen_anim_timer>0) mm_screen_anim_timer-=1
    if (mm_screen_anim_timer<0) mm_screen_anim_timer+=1

    -- increase v
    if (mm_screen_i==1 and v<1) v+=1/60
    if (mm_screen_i==0 and v>0) v-=1/60
    if (mm_screen_i==0 and v<0) v+=1/60
    if (mm_screen_i==-1 and v>-1) v-=1/60

    -- spawn ash
    ash_timer+=1
    if ash_timer>30 then
        ash_timer = 0
        for i=0,5 do
            spawn_ash(rnd(128),rnd(128),{6,5,13})
        end
    end

    -- animate ghost
    ghost_timer+=1
    if (ghost_timer>180) ghost_timer = 0
end

function _main_menu_d()
    cls(2)

    local screen_anim_x = -easeinoutquad(v) * 128 --* mm_screen_change_delta
    --print(mm_screen_i.."|"..v.."|"..screen_anim_x,20,20,8)
    -- title screen
    sspr(0,64,64,32,screen_anim_x+32,20)
    print("press ❎ to start",screen_anim_x+30, 68, blink_color1.color)
    print("press ➡️ for the rules", screen_anim_x+20, 76, 6)

    -- rules
    local rules_screen_anim_x = screen_anim_x +128
    print("rules",rules_screen_anim_x+44, 20, 6)
    print("- ❎ to place/pickup torches",rules_screen_anim_x+5, 40, 6)
    print("- place torches near flames",rules_screen_anim_x+5, 48, 6)
    print("- powered torches can attack",rules_screen_anim_x+5, 56, 6)
    print("- torches consume flames",rules_screen_anim_x+5, 64, 6)
    print("- defeat all waves of enemies",rules_screen_anim_x+5, 72, 6)
    print("- defend the mausoleum!",rules_screen_anim_x+5, 80, 6)
    
    -- todo: add credits
    -- -- credits
    -- local credits_screen_anim_x=screen_anim_x-256
    -- print("credits",credits_screen_anim_x+36, 30, 6)

    -- draw ghost
    local ghost_x = easeoutinquart(ghost_timer/180) * 128
    local ghost_y = sin(ghost_timer/180)*3
    spr(16, ghost_x, 100+ghost_y)

end

function change_mode_main_menu()
    mode="start"
    music(3,1000)
end