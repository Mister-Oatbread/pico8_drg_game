

function _init()
    player=new_player()
    projectiles=new_projectiles()
    drilled_ground=new_drilled_ground()
    performance_monitor=new_performance_monitor()
end

function _update()
    performance_monitor.reset_cpu_load()
    player.update()
    drilled_ground.update()
    projectiles.update()
    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    drilled_ground.draw()
    player.draw()
    projectiles.draw()
    performance_monitor.register_load()
    performance_monitor.print_current()
end


