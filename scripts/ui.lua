function _ui_i()
    blink_color1 = {
        colors={6,7,7},
        ci=1,
        color=5
    }
    blink_color2 = {
        colors={8,7},
        ci=1,
        color=5
    }

    blink_txt_souls_timer=0
    blink_txt_torch_timer=0
end

function _ui_u()
    blink_color1.ci+=1/30
    if(blink_color1.ci>#blink_color1.colors+1) blink_color1.ci=1
    blink_color1.color=blink_color1.colors[flr(blink_color1.ci)]

    blink_color2.ci+=1/7
    if(blink_color2.ci>#blink_color2.colors+1) blink_color2.ci=1
    blink_color2.color=blink_color2.colors[flr(blink_color2.ci)]

    if(blink_txt_souls_timer>0) blink_txt_souls_timer-=1
    if(blink_txt_torch_timer>0) blink_txt_torch_timer-=1
end

function _ui_d()
    local lvl_offset=(selected_lvl-1) * 128
    rectfill(0+lvl_offset,118,128+lvl_offset,128,2)
    
    spr(16,0+lvl_offset,119)

    -- override color for text base on status
    local txt_color_souls,txt_color_torches = 6,6
    if (blink_txt_souls_timer>0) txt_color_souls = blink_color2.color
    if (blink_txt_torch_timer>0) txt_color_torches = blink_color2.color

    print("souls:"..souls,8+lvl_offset,121,txt_color_souls)
    print("waves:"..#waves.."/"..tot_waves,44+lvl_offset,121,6)
    print("torches:"..available_torches,84+lvl_offset,121,txt_color_torches)
end