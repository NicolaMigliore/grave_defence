function _level_select_i()
    selected_lvl=1
    lvl_select_anim=0
    ash_timer=0
end

function _level_select_u()
    if (btnp(➡️) and selected_lvl<3) selected_lvl+=1
    if (btnp(⬅️) and selected_lvl>1) selected_lvl-=1
    if btnp(❎) then
        mode="game"
        camera_x=(selected_lvl-1)*128
        camera(camera_x)
        load_lvl(selected_lvl)
    end
    if btnp(🅾️) then
        change_mode_main_menu()
    end

    -- update animation
    lvl_select_anim-=1
    if (lvl_select_anim<=0) lvl_select_anim=60

    -- spawn ash
    ash_timer+=1
    if ash_timer>30 then
        ash_timer = 0
        for i=0,5 do
            spawn_ash(rnd(128),rnd(128),{6,5,13})
        end
    end
end

function _level_select_d()
    cls(2)
    rectfill(10,56,15,62,6)
    
    print("level-"..selected_lvl, 52, 30, 6)
    
    line(15,59,62,59,6)
    rectfill(62,56,67,62,6)
    line(67,59,114,59,6)
    rectfill(114,56,119,62,6)

    local x=9+52*(selected_lvl-1)
    local y=45+(lvl_select_anim > 30 and 1 or 0)
    spr(16,x,y)
    print("use ⬅️➡️ to select a level", 14, 80, 6)
    print("press ❎ to start",33, 88, blink_color1.color)
    print("press 🅾️ to return",33, 96, blink_color1.color)
end

function change_mode_level_select()
    mode="level_select"
    camera(0)
    music(2,2000)
end