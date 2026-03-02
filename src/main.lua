

function _init()
    player=new_player()
    projectiles=new_projectiles()
    drilled_ground=new_drilled_ground()
    resources=new_resources()
    map=new_map()

    game_logic=new_game_logic()

    performance_monitor=new_performance_monitor()
end

function _update()
    -- hacky stuff start
    difficulty=2
    points=0
    resource_spawn_rate=.01
    game_status="playing"
    resource_spawn_ratios = {
        1, -- red_sugar
        1, -- nitra
        1, -- gold
    }
    resource_spawn_probs = get_cum_probs(resource_spawn_ratios)
    -- hacky stuff end

    performance_monitor.reset_cpu_load()
    projectiles.update()
    resources.update()
    map.update()
    drilled_ground.update()
    player.update()

    game_logic.update()

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    resources.draw()
    projectiles.draw()
    map.draw_wall()
    drilled_ground.draw()
    player.draw()
    map.draw_super_wall()

    performance_monitor.register_load()
    performance_monitor.print_current()
end


