

function _init()
    -- hacky stuff start
    music(-1,0,0)
    music(56,0,0)
    -- hacky stuff end

    cartdata("oatbreadsdrillerdash")
    coop=false

    player_1=new_player(1,"driller")
    player_2=new_player(2,"gunner")
    players={player_1}
    if coop then add(players,player_2) end
    projectiles=new_projectiles()
    resources=new_resources()
    creatures=new_creatures()
    map=new_map()
    hud=new_hud()
    props=new_props()

    title_screen=new_title_screen()
    death_screen=new_death_screen()
    game_logic=new_game_logic()

    performance_monitor=new_performance_monitor()

    at_title_screen=true
    playing=false
    at_death_screen=false
end

function _update()
    -- hacky stuff start
    -- hacky stuff end

    performance_monitor.reset_cpu_load()
    if not at_death_screen then
        projectiles.update()
        resources.update()
        map.update()
        player_1.update()
        if coop then player_2.update() end

        creatures.update()
        props.update()
        game_logic.update()
    end

    performance_monitor.register_load()
end

function _draw()
    cls(1)
    camera(101,101)
    map.draw_terrain()
    map.draw_wall()
    map.draw_obstacles()
    props.draw_props()
    map.draw_drilled_ground()
    resources.draw()
    creatures.draw()
    projectiles.draw()
    if coop then player_2.draw() end
    player_1.draw()
    props.draw_particles()
    -- if at_title_screen then title_screen.draw() end
    map.draw_vines()
    map.draw_super_wall()
    hud.draw(player_1)
    if coop then hud.draw(player_2) end

    -- pset(223,101,at_title_screen and 11 or 8)
    -- pset(224,101,playing and 11 or 8)
    -- pset(225,101,at_death_screen and 11 or 8)

    if at_death_screen then
        cls(1)
        map.draw_wall()
        map.draw_super_wall()
        if coop then player_2.draw() end
        player_1.draw()
        death_screen.draw()
        performance_monitor.print_summary()
    end

    performance_monitor.register_load()
    performance_monitor.print_current()
end


