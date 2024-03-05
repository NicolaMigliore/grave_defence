function _lvl_u()
    if cur_wave!=nil then
        if cur_wave.cd>0 then
            cur_wave.cd-=1
        elseif cur_wave.nbr>0 then
            --spawn next enemy
            if (cur_wave.cur_enemy_cd==nil)  cur_wave.cur_enemy_cd = cur_wave.enemy_cd
            if cur_wave.cur_enemy_cd>0 then 
                cur_wave.cur_enemy_cd-=1
            else
                cur_wave.cur_enemy_cd = cur_wave.enemy_cd
                local e_coords = cur_wave.nodes[1]
                add_enemy(e_coords[1],e_coords[2],cur_wave.kind,cur_wave.nodes)
                cur_wave.nbr-=1
            end
        else
            del(waves, cur_wave)
            if (#waves > 0) cur_wave=waves[1] 
        end
    end
end

function _lvl_d()
    map()
end

function path_to_nodes(_path)
    local nodes={}
    for p in all(_path) do
        local coords = split(p)
        add(nodes,{coords[1]*8,coords[2]*8})
    end
    return nodes
end

function load_lvl(_cur_lvl)
    -- reload map
    reload(0x1000, 0x1000, 0x2000)

    -- reset values
    available_torches=3
    waves={}
    torches={}
    shots={}
    pflames={}
    enemies={}
    cur_wave=nil
    local path_1,path_2,path_3,path_4

    -- load level waves
    if _cur_lvl==1 then
        souls=10
        available_torches=4
        -- setup nodes
        path_1 = path_to_nodes({"0,1","1,1","2,1","3,1","3,2","3,3","3,4","4,4","5,4","6,4","6,5","6,6","6,7","6,8","6,9","6,10","6,11","6,13","5,13","4,13","3,13","2,13","2,12","2,11"})
        path_2 = path_to_nodes({"0,1","1,1","2,1","3,1","3,2","3,3","3,4","4,4","5,4","6,4","7,4","8,4","9,4","10,4","11,4","12,4","13,4","14,4","14,5","14,6","14,7","14,8","14,9","14,10","14,11","14,12","14,13","13,13","12,13","11,13","10,13","9,13","8,13","7,13","6,13","5,13","4,13","3,13","2,13","2,12","2,11"})
        waves = {
            { kind=1, nbr=10, cd=60, cur_enemy_cd=60, enemy_cd=120, nodes=path_1 },
            { kind=1, nbr=7, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=1, nbr=10, cd=120, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 }
        }
    elseif _cur_lvl==2 then
        souls=10
        available_torches=5
        -- setup nodes
        path_1 = path_to_nodes({"29,15","29,14","29,13","29,12","29,11","28,11","27,11","26,11","25,11","24,11","23,11","22,11","21,11","20,11","19,11","18,11","17,11","17,10","17,9","17,8","17,7","17,6","17,5","18,4","18,3"})
        path_2 = path_to_nodes({"29,15","29,14","29,13","29,12","29,11","29,10","29,9","29,8","29,7","29,6","29,5","29,4","29,3","29,2","28,2","27,2","26,2","25,2","24,2","23,2", "23,3","23,4","23,5","22,5","21,5","20,5","19,5","18,5","18,4","18,3"})
        path_3 = path_to_nodes({"29,15","29,14","29,13","29,12","29,11","28,11","27,11","26,11","25,11","24,11","23,11","23,10","23,9","23,8","23,7","23,6","23,5","22,5","21,5","20,5","19,5","18,5","18,3"})
        waves = {
            { kind=1, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 }, 
            { kind=2, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=360, nodes=path_2 },
            { kind=1, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_3 },
            { kind=2, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=360, nodes=path_1 },
            { kind=1, nbr=5, cd=60, cur_enemy_cd=120, enemy_cd=120, nodes=path_2 },
            { kind=1, nbr=10, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 }
        }
    elseif _cur_lvl==3 then
        souls=5
        available_torches=5
        -- setup nodes
        path_1 = path_to_nodes({"32,11","33,11","34,11","35,11","36,11","37,11","38,11","39,11","39,10","39,9","39,8","39,7","39,6","39,5","39,4"})
        path_2 = path_to_nodes({"47,11","46,11","45,11","44,11","43,11","42,11","41,11","40,11","40,10","40,9","40,8","40,7","40,6","40,5","40,4"})
        path_3 = path_to_nodes({"32,1","33,1","34,1","35,1","35,2","35,3","35,4","35,5","36,5","37,5","38,5","39,5","40,4"})
        path_4 = path_to_nodes({"47,1","46,1","45,1","44,1","44,2","44,3","44,4","44,5","43,5","42,5","41,5","40,5","39,4"})
        waves = {
            { kind=1, nbr=7, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 },
            { kind=1, nbr=7, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=2, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=240, nodes=path_3 },
            { kind=1, nbr=5, cd=300, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=3, nbr=1, cd=60, cur_enemy_cd=0, enemy_cd=240, nodes=path_1 },
            { kind=3, nbr=1, cd=60, cur_enemy_cd=0, enemy_cd=240, nodes=path_2 },
            { kind=2, nbr=3, cd=600, cur_enemy_cd=0, enemy_cd=120, nodes=path_4 },
            { kind=1, nbr=7, cd=600, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=1, nbr=7, cd=120, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 }
        }
    end

    tot_waves = #waves
    if (#waves > 0) cur_wave=waves[1]

    -- spawn flames
    spawn_flames((selected_lvl-1)*16)

    -- place player
    player.x= (selected_lvl)*128 - 64

    -- play music
    --sfx() -- todo: play sfx
    music(0,1000)
end

function sub_soul()
    souls-=1
    sfx(3)
    blink_txt_souls_timer=30
    if souls<1 then
        change_mode_level_fail()
    end
end

function is_level_complete()
    local is_complete = false
    if (#waves == 0 and #enemies == 0) is_complete = true
    return is_complete
end