

function _init()
    player=new_player()
    projectiles=new_projectiles()
    drilled_ground=new_drilled_ground()
    resources=new_resources()

    game_logic=new_game_logic()

    performance_monitor=new_performance_monitor()
end

function _update()
    -- hacky stuff
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

    performance_monitor.reset_cpu_load()
    player.update()
    drilled_ground.update()
    projectiles.update()
    resources.update()

    game_logic.update()

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    drilled_ground.draw()
    resources.draw()
    player.draw()
    projectiles.draw()

    performance_monitor.register_load()
    performance_monitor.print_current()
end


