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
        add(nodes,{(coords[1]*8)+4,(coords[2]*8)+2})
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
        path_1 = path_to_nodes({"0,1","3,1","3,4","6,4","6,8","6,13","2,13","1,11"})
        path_2 = path_to_nodes({"0,1","3,1","3,4","6,4","14,4","14,8","14,13","6,13","2,13","1,11"})        
        waves = {
            { kind=1, nbr=10, cd=60, cur_enemy_cd=60, enemy_cd=120, nodes=path_1 },
            { kind=1, nbr=7, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=1, nbr=10, cd=120, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 }
        }
    elseif _cur_lvl==2 then
        souls=10
        available_torches=5
        -- setup nodes
        path_1 = path_to_nodes({"29,15","29,11","23,11","17,11","17,3","18,3"})
        path_2 = path_to_nodes({"29,15","29,6","29,2","23,2","23,5","18,5","18,3"})
        path_3 = path_to_nodes({"29,15","29,11","23,11","23,5","18,5","18,3"})
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
        path_1 = path_to_nodes({"31,11","39,11","40,8","39,4"})
        path_2 = path_to_nodes({"48,11","40,11","39,8","40,4"})
        path_3 = path_to_nodes({"31,1","35,1","35,5","39,5","40,4"})
        path_4 = path_to_nodes({"48,1","44,1","44,5","40,5","39,4"})
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
    elseif _cur_lvl==4 then
        souls=10
        available_torches=5
        -- setup nodes
        path_1 = path_to_nodes({"47,12","53,12","59,12","59,5","61,5","62,3"})
        path_2 = path_to_nodes({"47,2","53,2","53,12","59,12","59,5","61,5","62,3"})
        waves = {
            { kind=1, nbr=10, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 }, 
            { kind=1, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 },
            { kind=1, nbr=10, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=1, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 },
            { kind=1, nbr=10, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=2, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=360, nodes=path_1 }
        }
    elseif _cur_lvl==5 then
        souls=5
        available_torches=5
        -- setup nodes
        path_1 = path_to_nodes({"80,2","77,2","77,4","69,4","69,8","77,8","77,12","71,12","66,12","65,10"})
        path_2 = path_to_nodes({"63,1","69,1","69,4","69,8","77,8","77,12","71,12","66,12","65,10"})
        path_3 = path_to_nodes({"80,12","71,12","66,12","65,10"})
        waves = {
            { kind=2, nbr=2, cd=60, cur_enemy_cd=0, enemy_cd=360, nodes=path_1 },
            { kind=1, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=2, nbr=2, cd=60, cur_enemy_cd=0, enemy_cd=360, nodes=path_2 },
            { kind=1, nbr=5, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 },

            { kind=1, nbr=10, cd=60, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=1, nbr=10, cd=0, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 },
            { kind=3, nbr=2, cd=60, cur_enemy_cd=0, enemy_cd=360, nodes=path_2 },
            { kind=3, nbr=2, cd=0, cur_enemy_cd=0, enemy_cd=360, nodes=path_1 },
            { kind=1, nbr=5, cd=0, cur_enemy_cd=0, enemy_cd=120, nodes=path_1 },
            { kind=1, nbr=5, cd=0, cur_enemy_cd=0, enemy_cd=120, nodes=path_2 },
            { kind=3, nbr=1, cd=0, cur_enemy_cd=0, enemy_cd=360, nodes=path_3 }
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