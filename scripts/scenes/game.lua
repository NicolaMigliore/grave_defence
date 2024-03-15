function _game_i()
    _player_i()
    _enemy_i()
    _pf_i()
    _torch_i()
end

function _game_u()
    _player_u()
    _enemy_u()
    _pf_u()
    _torch_u()
    _lvl_u()
end

function _game_d()
    cls(3)

    _lvl_d()
    _enemy_d()
    _pf_d()
    _torch_d()
    _player_d()
    _ui_d()
end

function change_mode_game()
    mode="game"
    camera_x=(selected_lvl-1)*128
    camera(camera_x)
    load_lvl(selected_lvl)
    configure_menu()
end