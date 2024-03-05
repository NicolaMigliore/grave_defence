function _lvl_fail_u()
    if (btnp(❎)) change_mode_level_select()
end

function _lvl_fail_d()
    local camera_ox = (selected_lvl-1)*128
    rectfill(0+camera_ox,30,128+camera_ox,54,2)
    print("game over",46+camera_ox,32,6)
    print("the skeletons have taken over",4+camera_ox,40,6)
    print("press ❎ to select a level",16+camera_ox,48,blink_color1.color)
end

function change_mode_level_fail()
    shots={}            -- clear all existing shots
    _game_d()           -- draw next frame of the game
    mode="level_fail"
    sfx(1)
end