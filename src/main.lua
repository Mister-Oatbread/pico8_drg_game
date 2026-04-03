

function _init()
    -- hacky stuff start
    music(-1)
    music(1)
    -- hacky stuff end

    player_1=new_player(1)
    player_2=new_player(2)
    projectiles=new_projectiles()
    resources=new_resources()
    map=new_map()
    hud=new_hud()

    title_screen=new_title_screen()
    game_logic=new_game_logic()
    creatures=new_creatures()

    performance_monitor=new_performance_monitor()
end

function _update()
    -- hacky stuff start
    difficulty=2
    game_logic.set_difficulty(2)
    coop=false
    points=0
    game_status="playing"
    -- hacky stuff end

    performance_monitor.reset_cpu_load()
    projectiles.update()
    resources.update()
    map.update()
    player_1.update()
    if coop then player_2.update() end

    creatures.update()
    game_logic.update()

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    -- map.draw_terrain()
    map.draw_wall()
    map.draw_obstacles()
    map.draw_drilled_ground()
    resources.draw()
    creatures.draw()
    projectiles.draw()
    if coop then player_2.draw() end
    player_1.draw()
    -- if game_status=="title_screen" then title_screen.draw() end
    -- title_screen.draw()
    -- map.draw_vines()
    map.draw_super_wall()
    hud.draw(player_1)
    if coop then hud.draw(player_2) end

    performance_monitor.register_load()
    performance_monitor.print_current()
end


