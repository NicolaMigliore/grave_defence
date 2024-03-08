function _init()
    debug=""
    mode="start"
    banner_x=0
    camera_x=0
    _main_menu_i()
    _level_select_i()
    _game_i()
    _ui_i()
    _particles_i()

    cartdata("elfamir_gravedefence_1")
    load_settings()
    set_menu_controlls()
    -- snap_ctrl=false
end

function _update60()
    if mode=="start"then 
        _main_menu_u()
    elseif mode=="level_select" then
        _level_select_u()
    elseif mode=="level_complete" then
        _lvl_complete_u()
    elseif mode=="level_fail" then
        _lvl_fail_u()
    elseif mode=="game" then
        _game_u()
    end
    _ui_u()
    _particles_u()
end

function _draw()
    if mode=="start"then 
        _main_menu_d()
    elseif mode=="level_select" then
        _level_select_d()
    elseif mode=="level_complete" then
        _lvl_complete_d()
    elseif mode=="level_fail" then
        _lvl_fail_d()
    elseif mode=="game" then
        _game_d()
    end
    _particles_d()


    --debugging
    if debug != "" then
        local ox = 10 + (selected_lvl-1)*128
        print(debug,10,8)
    end
    -- if btnp(🅾️) then
    --     --stop()
    --     --mode="level_selectS"
    --     change_mode_level_complete()
    -- end
end

function load_settings()
    snap_ctrl = dget(0) == 1
end

function toggle_snap_ctrl()
    snap_ctrl = not snap_ctrl
    dset(0, snap_ctrl and 1 or 0)
    set_menu_controlls()
    snap_player_to_grid()
    return true
end

function set_menu_controlls()
    local label = "snap ctrl □"
    if (snap_ctrl) label = "snap ctrl ■"
    menuitem(1, label, toggle_snap_ctrl)
end