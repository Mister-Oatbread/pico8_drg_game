

function _init()
    player_1=new_player(1)
    player_2=new_player(2)
    projectiles=new_projectiles()
    resources=new_resources()
    map=new_map()
    hud=new_hud()

    game_logic=new_game_logic()

    performance_monitor=new_performance_monitor()
end

function _update()
    -- hacky stuff start
    difficulty=2
    points=0
    resource_spawn_rate=.01
    game_status="playing"
    resource_spawn_ratios={
        1, -- red_sugar
        1, -- nitra

    -- activate secondary palette
        1, -- gold
    }
    obstacle_spawn_rate=.2
    obstacle_spawn_ratios={
        15, -- small
        1, -- big
    }

    obstacle_spawn_probs=get_cum_probs(obstacle_spawn_ratios)
    resource_spawn_probs=get_cum_probs(resource_spawn_ratios)
    -- hacky stuff end

    performance_monitor.reset_cpu_load()
    projectiles.update()
    resources.update()
    map.update()
    player_1.update()

    game_logic.update()

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    map.draw_terrain()
    map.draw_wall()
    map.draw_obstacles()
    map.draw_drilled_ground()
    resources.draw()
    projectiles.draw()
    player_1.draw()
    map.draw_vines()
    map.draw_super_wall()
    hud.draw(player_1)

    performance_monitor.register_load()
    performance_monitor.print_current()
end


